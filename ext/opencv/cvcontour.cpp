/************************************************************

   cvcontour.cpp -

   $Author: lsxi $

   Copyright (C) 2007 Masakazu Yonekura

************************************************************/
#include "cvcontour.h"
/*
 * Document-class: OpenCV::CvContour
 *
 * Contour.
 * CvMat#find_contours
 */
__NAMESPACE_BEGIN_OPENCV
__NAMESPACE_BEGIN_CVCONTOUR

#define APPROX_POLY_OPTION(op) rb_get_option_table(rb_klass, "APPROX_OPTION", op)
#define APPROX_POLY_METHOD(op) CVMETHOD("APPROX_POLY_METHOD", LOOKUP_CVMETHOD(op, "method"), CV_POLY_APPROX_DP)
#define APPROX_POLY_ACCURACY(op) NUM2DBL(LOOKUP_CVMETHOD(op, "accuracy"))
#define APPROX_POLY_RECURSIVE(op) TRUE_OR_FALSE(LOOKUP_CVMETHOD(op, "recursive"))

VALUE rb_allocate(VALUE klass);
void cvcontour_free(void *ptr);

VALUE rb_klass;

VALUE
rb_class()
{
  return rb_klass;
}

void
define_ruby_class()
{
  if (rb_klass)
    return;
  /* 
   * opencv = rb_define_module("OpenCV");
   * cvseq = rb_define_class_under(opencv, "CvSeq");
   * curve = rb_define_module_under(opencv, "Curve");
   * pointset = rb_define_module_under(opencv, "PointSet");
   *
   * note: this comment is used by rdoc.
   */
  VALUE opencv = rb_module_opencv();
  VALUE cvseq = cCvSeq::rb_class();
  VALUE curve = mCurve::rb_module();
  VALUE pointset = mPointSet::rb_module();

  rb_klass = rb_define_class_under(opencv, "CvContour", cvseq);
  rb_include_module(rb_klass, curve);
  rb_include_module(rb_klass, pointset);

  rb_define_alloc_func(rb_klass, rb_allocate);

  VALUE approx_option = rb_hash_new();
  rb_define_const(rb_klass, "APPROX_OPTION", approx_option);
  rb_hash_aset(approx_option, ID2SYM(rb_intern("method")), INT2FIX(CV_POLY_APPROX_DP));
  rb_hash_aset(approx_option, ID2SYM(rb_intern("accuracy")), rb_float_new(1.0));
  rb_hash_aset(approx_option, ID2SYM(rb_intern("recursive")), Qfalse);
  
  rb_define_private_method(rb_klass, "initialize", RUBY_METHOD_FUNC(rb_initialize), -1);
  rb_define_method(rb_klass, "rect", RUBY_METHOD_FUNC(rb_rect), 0);
  rb_define_method(rb_klass, "color", RUBY_METHOD_FUNC(rb_color), 0);
  rb_define_method(rb_klass, "color=", RUBY_METHOD_FUNC(rb_set_color), 1);
  rb_define_method(rb_klass, "reserved", RUBY_METHOD_FUNC(rb_reserved), 0);
  rb_define_method(rb_klass, "approx_poly", RUBY_METHOD_FUNC(rb_approx_poly), -1);
  rb_define_alias(rb_klass, "approx", "approx_poly");
  rb_define_method(rb_klass, "bounding_rect", RUBY_METHOD_FUNC(rb_bounding_rect), 0);
  rb_define_method(rb_klass, "create_tree", RUBY_METHOD_FUNC(rb_create_tree), -1);
  rb_define_method(rb_klass, "in?", RUBY_METHOD_FUNC(rb_in_q), 1);
  rb_define_method(rb_klass, "measure_distance", RUBY_METHOD_FUNC(rb_measure_distance), 1);
  rb_define_method(rb_klass, "point_polygon_test", RUBY_METHOD_FUNC(rb_point_polygon_test), 2);
}

VALUE
rb_allocate(VALUE klass)
{
  CvContour *ptr;
  return Data_Make_Struct(klass, CvContour, mark_root_object, unregister_object, ptr);
}

VALUE
rb_initialize(int argc, VALUE *argv, VALUE self)
{
  VALUE storage;
  rb_scan_args(argc, argv, "01", &storage);

  if (NIL_P(storage))
    storage = cCvMemStorage::new_object(0);
  else
    storage = CHECK_CVMEMSTORAGE(storage);

  CvContour* contour = (CvContour*)DATA_PTR(self);
  try {
    contour = (CvContour*)cvCreateSeq(CV_SEQ_ELTYPE_POINT, sizeof(CvContour),
				      sizeof(CvPoint), CVMEMSTORAGE(storage));
  }
  catch (cv::Exception& e) {
    raise_cverror(e);
  }
  register_root_object((CvSeq*)contour, storage);

  return self;
}

VALUE
rb_rect(VALUE self)
{
  return cCvRect::new_object(CVCONTOUR(self)->rect);
}

VALUE
rb_color(VALUE self)
{
  return INT2NUM(CVCONTOUR(self)->color);
}

VALUE
rb_set_color(VALUE self, VALUE color)
{
  CVCONTOUR(self)->color = NUM2INT(color);
  return self;
}

VALUE
rb_reserved(VALUE self)
{
  return rb_ary_new3(3,
		     INT2NUM(CVCONTOUR(self)->reserved[0]),
		     INT2NUM(CVCONTOUR(self)->reserved[1]),
		     INT2NUM(CVCONTOUR(self)->reserved[2]));
}

/*
 * call-seq:
 *   approx_poly(<i>approx_poly_option</i>) -> cvcontour
 *
 * Approximates polygonal curve(s) with desired precision.
 * <i>approx_poly_option</i> should be Hash include these keys.
 *   :method - Approximation method.
 *     :dp - corresponds to Douglas-Peucker algorithm.
 *   :accuracy - approximation accuracy. (high-accuracy will create more simple contours)
 *   :recursive - (default false)
 *      If not nil or false, the function approximates all chains that access can be obtained to
 *      from self by h_next or v_next links. If 0, approximated this one.
 */

VALUE
rb_approx_poly(int argc, VALUE *argv, VALUE self)
{
  VALUE approx_poly_option, storage;
  rb_scan_args(argc, argv, "01", &approx_poly_option);  
  approx_poly_option = APPROX_POLY_OPTION(approx_poly_option);
  storage = cCvMemStorage::new_object();
  /*
    CvSeq *contour = cvApproxPoly(CVCONTOUR(self), sizeof(CvContour), CVMEMSTORAGE(storage),
    APPROX_POLY_METHOD(approx_poly_option),
    APPROX_POLY_ACCURACY(approx_poly_option),
    APPROX_POLY_RECURSIVE(approx_poly_option));
    return cCvSeq::new_sequence(cCvContour::rb_class(), contour, cCvPoint::rb_class(), storage);
  */
  return Qnil;
}

/*
 * call-seq:
 *   bounding_rect -> rect
 *
 * Calculates up-right bounding rectangle of point set.
 * 
 */
VALUE
rb_bounding_rect(VALUE self)
{
  CvRect rect;
  try {
    rect = cvBoundingRect(CVCONTOUR(self), 1);
  }
  catch (cv::Exception& e) {
    raise_cverror(e);
  }
  return cCvRect::new_object(rect);
}

/*
 * call-seq:
 *   create_tree([threshold = 0.0]) -> cvcontourtree
 *
 * Creates hierarchical representation of contour.
 * If the parameter <i>threshold</i> is less than or equal to 0,
 * the method creates full binary tree representation.
 * If the threshold is greater than 0, the function creates
 * representation with the precision threshold: 
 */
VALUE
rb_create_tree(int argc, VALUE *argv, VALUE self)
{
  VALUE threshold, storage;
  rb_scan_args(argc, argv, "01", &threshold);
  storage = cCvMemStorage::new_object();
  CvContourTree *tree = NULL;
  try {
    tree = cvCreateContourTree(CVSEQ(self), CVMEMSTORAGE(storage), IF_DBL(threshold, 0.0));
  }
  catch (cv::Exception& e) {
    raise_cverror(e);
  }
  return cCvSeq::new_sequence(cCvContourTree::rb_class(), (CvSeq*)tree, cCvPoint::rb_class(), storage);
}

/*
 * call-seq:
 *    in?(<i>point</i>) -> true or nil or false
 *
 * Determines whether the <i>point</i> is inside contour(true), outside(false) or lies on an edge(nil).
 */
VALUE
rb_in_q(VALUE self, VALUE point)
{
  double n = 0;
  try {
    n = cvPointPolygonTest(CVARR(self), VALUE_TO_CVPOINT2D32F(point), 0);
  }
  catch (cv::Exception& e) {
    raise_cverror(e);
  }
  return n == 0 ? Qnil : n > 0 ? Qtrue : Qfalse;
}

/*
 * call-seq:
 *    measure_distance(<i>point</i>) -> float
 *
 * Return distance between the point and the nearest contour edge.
 */
VALUE
rb_measure_distance(VALUE self, VALUE point)
{
  double distance = 0;
  try {
    distance = cvPointPolygonTest(CVARR(self), VALUE_TO_CVPOINT2D32F(point), 1);
  }
  catch (cv::Exception& e) {
    raise_cverror(e);
  }
  return rb_float_new(distance);
}

/*
 * call-seq:
 *    point_polygon_test(<i>point, measure_dist</i>) -> float
 *
 * Determines whether the point is inside a contour, outside, or lies on an edge (or coinsides with a vertex).
 * It returns positive, negative or zero value, correspondingly. When measure_dist = false or 0, the return value is +1, -1 and 0, respectively. When measure_dist = true or 1, it is a signed distance between the point and the nearest contour edge.
 */
VALUE
rb_point_polygon_test(VALUE self, VALUE point, VALUE measure_dist)
{
  int measure_dist_flag;

  if (measure_dist == Qtrue)
    measure_dist_flag = 1;
  else if (measure_dist == Qfalse)
    measure_dist_flag = 0;
  else
    measure_dist_flag = NUM2INT(measure_dist);

  double dist = Qnil;
  try {
    dist = cvPointPolygonTest(CVARR(self), VALUE_TO_CVPOINT2D32F(point), measure_dist_flag);
  }
  catch (cv::Exception& e) {
    raise_cverror(e);
  }
  
  /* cvPointPolygonTest returns 100, -100 or 0 when measure_dist = 0 */
  if ((!measure_dist_flag) && ((int)dist) != 0)
    dist = (dist > 0) ? 1 : -1;

  return rb_float_new(dist);
}

VALUE new_object()
{  
  VALUE object = rb_allocate(rb_klass);
  rb_initialize(0, NULL, object);
  return object;
}

__NAMESPACE_END_CVCONTOUR
__NAMESPACE_END_OPENCV

