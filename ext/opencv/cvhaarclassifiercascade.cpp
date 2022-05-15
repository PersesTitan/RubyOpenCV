/************************************************************

  cvhaarclassifercascade.cpp -

  $Author: lsxi $

  Copyright (C) 2005-2007 Masakazu Yonekura

************************************************************/
#include "cvhaarclassifiercascade.h"
/*
 * Document-class: OpenCV::CvHaarClassifierCascade
 *
 * CvHaarClassifierCascade object is "fast-object-detector".
 * This detector can discover object (e.g. human's face) from image.
 *
 * Find face-area from picture "lena"...
 * link:../images/face_detect_from_lena.jpg
 */
__NAMESPACE_BEGIN_OPENCV
__NAMESPACE_BEGIN_CVHAARCLASSIFERCASCADE

VALUE rb_klass;

VALUE
rb_class()
{
  return rb_klass;
}

void define_ruby_class()
{
  if (rb_klass)
    return;
  /* 
   * opencv = rb_define_module("OpenCV");
   * 
   * note: this comment is used by rdoc.
   */
  VALUE opencv = rb_module_opencv();
  
  rb_klass = rb_define_class_under(opencv, "CvHaarClassifierCascade", rb_cObject);
  rb_define_alloc_func(rb_klass, rb_allocate);
  rb_define_singleton_method(rb_klass, "load", RUBY_METHOD_FUNC(rb_load), 1);
  rb_define_method(rb_klass, "detect_objects", RUBY_METHOD_FUNC(rb_detect_objects), -1);
}

VALUE
rb_allocate(VALUE klass)
{
  return OPENCV_OBJECT(klass, 0);
}

void
cvhaarclassifiercascade_free(void* ptr)
{
  if (ptr) {
    CvHaarClassifierCascade* cascade = (CvHaarClassifierCascade*)ptr;
    cvReleaseHaarClassifierCascade(&cascade);
  }
}

/*
 * call-seq:
 *   CvHaarClassiferCascade.load(<i>path</i>) -> object-detector
 * 
 * Load trained cascade of haar classifers from file.
 * Object detection classifiers are stored in XML or YAML files.
 * sample of object detection classifier files is included by OpenCV.
 *
 * You can found these at
 *    C:\Program Files\OpenCV\data\haarcascades\*.xml (Windows, default install path)
 *
 * e.g. you want to try to detect human's face.
 *    detector = CvHaarClassiferCascade.load("haarcascade_frontalface_alt.xml")
 */
VALUE
rb_load(VALUE klass, VALUE path)
{
  CvHaarClassifierCascade *cascade = NULL;
  try {
    cascade = (CvHaarClassifierCascade*)cvLoad(StringValueCStr(path), 0, 0, 0);
  }
  catch (cv::Exception& e) {
    raise_cverror(e);
  }
  if (!CV_IS_HAAR_CLASSIFIER(cascade))
    rb_raise(rb_eArgError, "invalid format haar classifier cascade file.");
  return Data_Wrap_Struct(klass, 0, cvhaarclassifiercascade_free, cascade);
}

/*
 * call-seq:
 *   detect_objects(image[, options]) -> cvseq(include CvAvgComp object)
 *   detect_objects(image[, options]){|cmp| ... } -> cvseq(include CvAvgComp object)
 *
 * Detects objects in the image. This method finds rectangular regions in the
 * given image that are likely to contain objects the cascade has been trained
 * for and return those regions as a sequence of rectangles.
 *
 * * <i>option</i> should be Hash include these keys.
 *   :scale_factor (should be > 1.0)
 *      The factor by which the search window is scaled between the subsequent scans,
 *      1.1 mean increasing window by 10%.
 *   :storage
 *      Memory storage to store the resultant sequence of the object candidate rectangles
 *   :flags
 *      Mode of operation. Currently the only flag that may be specified is CV_HAAR_DO_CANNY_PRUNING .
 *      If it is set, the function uses Canny edge detector to reject some image regions that contain
 *      too few or too much edges and thus can not contain the searched object. The particular threshold
 *      values are tuned for face detection and in this case the pruning speeds up the processing
 *   :min_neighbors
 *      Minimum number (minus 1) of neighbor rectangles that makes up an object.
 *      All the groups of a smaller number of rectangles than min_neighbors - 1 are rejected.
 *      If min_neighbors is 0, the function does not any grouping at all and returns all the detected
 *      candidate rectangles, whitch many be useful if the user wants to apply a customized grouping procedure.
 *   :min_size
 *      Minimum window size. By default, it is set to size of samples the classifier has been
 *      trained on (~20x20 for face detection).
 *   :max_size
 *      aximum window size to use. By default, it is set to the size of the image.
 */
VALUE
rb_detect_objects(int argc, VALUE *argv, VALUE self)
{ 
  VALUE image, options;
  rb_scan_args(argc, argv, "11", &image, &options);

  double scale_factor;
  int flags, min_neighbors;
  CvSize min_size, max_size;
  VALUE storage_val;
  if (NIL_P(options)) {
    scale_factor = 1.1;
    flags = 0;
    min_neighbors = 3;
    min_size = max_size = cvSize(0, 0);
    storage_val = cCvMemStorage::new_object();
  }
  else {
    scale_factor = IF_DBL(LOOKUP_CVMETHOD(options, "scale_factor"), 1.1);
    flags = IF_INT(LOOKUP_CVMETHOD(options, "flags"), 0);
    min_neighbors = IF_INT(LOOKUP_CVMETHOD(options, "min_neighbors"), 3);
    VALUE min_size_val = LOOKUP_CVMETHOD(options, "min_size");
    min_size = NIL_P(min_size_val) ? cvSize(0, 0) : VALUE_TO_CVSIZE(min_size_val);
    VALUE max_size_val = LOOKUP_CVMETHOD(options, "max_size");
    max_size = NIL_P(max_size_val) ? cvSize(0, 0) : VALUE_TO_CVSIZE(max_size_val);
    storage_val = CHECK_CVMEMSTORAGE(LOOKUP_CVMETHOD(options, "storage"));
  }

  VALUE result = Qnil;
  try {
    CvSeq *seq = cvHaarDetectObjects(CVARR_WITH_CHECK(image), CVHAARCLASSIFIERCASCADE(self), CVMEMSTORAGE(storage_val),
			      scale_factor, min_neighbors, flags, min_size, max_size);
    result = cCvSeq::new_sequence(cCvSeq::rb_class(), seq, cCvAvgComp::rb_class(), storage_val);
    if (rb_block_given_p()) {
      for(int i = 0; i < seq->total; ++i)
	rb_yield(REFER_OBJECT(cCvAvgComp::rb_class(), cvGetSeqElem(seq, i), storage_val));
    }
  }
  catch (cv::Exception& e) {
    raise_cverror(e);
  }
  return result;
}

__NAMESPACE_END_CVHAARCLASSIFERCASCADE
__NAMESPACE_END_OPENCV
