# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = "opencv"
  s.version = "0.0.6.20120208234956"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["lsxi", "ser1zw", "pcting"]
  s.date = "2012-02-08"
  s.description = "OpenCV wrapper for Ruby\n"
  s.email = ["masakazu.yonekura@gmail.com", "", "pcting@gmail.com"]
  s.extensions = ["extconf.rb"]
  s.extra_rdoc_files = ["History.txt", "License.txt", "Manifest.txt"]
  s.files = [".gitignore", "Gemfile", "Gemfile.lock", "History.txt", "License.txt", "Manifest.txt", "README.rdoc", "Rakefile", "examples/alpha_blend.rb", "examples/box.png", "examples/box_in_scene.png", "examples/contours/bitmap-contours-with-labels.png", "examples/contours/bitmap-contours.png", "examples/contours/bounding-box-detect-canny.rb", "examples/contours/contour_retrieval_modes.rb", "examples/contours/rotated-boxes.jpg", "examples/convexhull.rb", "examples/face_detect.rb", "examples/find_obj.rb", "examples/houghcircle.rb", "examples/inpaint.png", "examples/inpaint.rb", "examples/lenna-rotated.jpg", "examples/lenna.jpg", "examples/match_kdtree.rb", "examples/paint.rb", "examples/snake.rb", "examples/stuff.jpg", "examples/tiffany.jpg", "ext/opencv/curve.cpp", "ext/opencv/curve.h", "ext/opencv/cvavgcomp.cpp", "ext/opencv/cvavgcomp.h", "ext/opencv/cvbox2d.cpp", "ext/opencv/cvbox2d.h", "ext/opencv/cvcapture.cpp", "ext/opencv/cvcapture.h", "ext/opencv/cvchain.cpp", "ext/opencv/cvchain.h", "ext/opencv/cvcircle32f.cpp", "ext/opencv/cvcircle32f.h", "ext/opencv/cvcondensation.cpp", "ext/opencv/cvcondensation.h", "ext/opencv/cvconnectedcomp.cpp", "ext/opencv/cvconnectedcomp.h", "ext/opencv/cvcontour.cpp", "ext/opencv/cvcontour.h", "ext/opencv/cvcontourtree.cpp", "ext/opencv/cvcontourtree.h", "ext/opencv/cvconvexitydefect.cpp", "ext/opencv/cvconvexitydefect.h", "ext/opencv/cverror.cpp", "ext/opencv/cverror.h", "ext/opencv/cvfeaturetree.cpp", "ext/opencv/cvfeaturetree.h", "ext/opencv/cvfont.cpp", "ext/opencv/cvfont.h", "ext/opencv/cvhaarclassifiercascade.cpp", "ext/opencv/cvhaarclassifiercascade.h", "ext/opencv/cvhistogram.cpp", "ext/opencv/cvhistogram.h", "ext/opencv/cvhumoments.cpp", "ext/opencv/cvhumoments.h", "ext/opencv/cvline.cpp", "ext/opencv/cvline.h", "ext/opencv/cvmat.cpp", "ext/opencv/cvmat.h", "ext/opencv/cvmatnd.cpp", "ext/opencv/cvmatnd.h", "ext/opencv/cvmemstorage.cpp", "ext/opencv/cvmemstorage.h", "ext/opencv/cvmoments.cpp", "ext/opencv/cvmoments.h", "ext/opencv/cvpoint.cpp", "ext/opencv/cvpoint.h", "ext/opencv/cvpoint2d32f.cpp", "ext/opencv/cvpoint2d32f.h", "ext/opencv/cvpoint3d32f.cpp", "ext/opencv/cvpoint3d32f.h", "ext/opencv/cvrect.cpp", "ext/opencv/cvrect.h", "ext/opencv/cvscalar.cpp", "ext/opencv/cvscalar.h", "ext/opencv/cvseq.cpp", "ext/opencv/cvseq.h", "ext/opencv/cvsize.cpp", "ext/opencv/cvsize.h", "ext/opencv/cvsize2d32f.cpp", "ext/opencv/cvsize2d32f.h", "ext/opencv/cvslice.cpp", "ext/opencv/cvslice.h", "ext/opencv/cvsparsemat.cpp", "ext/opencv/cvsparsemat.h", "ext/opencv/cvsurfparams.cpp", "ext/opencv/cvsurfparams.h", "ext/opencv/cvsurfpoint.cpp", "ext/opencv/cvsurfpoint.h", "ext/opencv/cvtermcriteria.cpp", "ext/opencv/cvtermcriteria.h", "ext/opencv/cvtwopoints.cpp", "ext/opencv/cvtwopoints.h", "ext/opencv/cvutils.cpp", "ext/opencv/cvutils.h", "ext/opencv/cvvideowriter.cpp", "ext/opencv/cvvideowriter.h", "ext/opencv/gui.cpp", "ext/opencv/gui.h", "ext/opencv/iplconvkernel.cpp", "ext/opencv/iplconvkernel.h", "ext/opencv/iplimage.cpp", "ext/opencv/iplimage.h", "ext/opencv/lib/opencv.rb", "ext/opencv/lib/opencv/psyched_yaml.rb", "ext/opencv/lib/opencv/version.rb", "ext/opencv/mouseevent.cpp", "ext/opencv/mouseevent.h", "ext/opencv/opencv.cpp", "ext/opencv/opencv.h", "ext/opencv/pointset.cpp", "ext/opencv/pointset.h", "ext/opencv/trackbar.cpp", "ext/opencv/trackbar.h", "ext/opencv/window.cpp", "ext/opencv/window.h", "extconf.rb", "images/CvMat_sobel.png", "images/CvMat_sub_rect.png", "images/CvSeq_relationmap.png", "images/face_detect_from_lena.jpg", "test/helper.rb", "test/runner.rb", "test/samples/airplane.jpg", "test/samples/baboon.jpg", "test/samples/baboon200.jpg", "test/samples/baboon200_rotated.jpg", "test/samples/blank0.jpg", "test/samples/blank1.jpg", "test/samples/blank2.jpg", "test/samples/blank3.jpg", "test/samples/blank4.jpg", "test/samples/blank5.jpg", "test/samples/blank6.jpg", "test/samples/blank7.jpg", "test/samples/blank8.jpg", "test/samples/blank9.jpg", "test/samples/cat.jpg", "test/samples/contours.jpg", "test/samples/fruits.jpg", "test/samples/haarcascade_frontalface_alt.xml.gz", "test/samples/inpaint-mask.bmp", "test/samples/lena-256x256.jpg", "test/samples/lena-32x32.jpg", "test/samples/lena-eyes.jpg", "test/samples/lena-inpaint.jpg", "test/samples/lena.jpg", "test/samples/lines.jpg", "test/samples/messy0.jpg", "test/samples/messy1.jpg", "test/samples/movie_sample.avi", "test/samples/one_way_train_0000.jpg", "test/samples/one_way_train_0001.jpg", "test/samples/partially_blank0.jpg", "test/samples/partially_blank1.jpg", "test/samples/smooth0.jpg", "test/samples/smooth1.jpg", "test/samples/smooth2.jpg", "test/samples/smooth3.jpg", "test/samples/smooth4.jpg", "test/samples/smooth5.jpg", "test/samples/smooth6.jpg", "test/samples/str-cv-rotated.jpg", "test/samples/str-cv.jpg", "test/samples/str-ov.jpg", "test/samples/stuff.jpg", "test/test_curve.rb", "test/test_cvavgcomp.rb", "test/test_cvbox2d.rb", "test/test_cvcapture.rb", "test/test_cvchain.rb", "test/test_cvcircle32f.rb", "test/test_cvconnectedcomp.rb", "test/test_cvcontour.rb", "test/test_cvcontourtree.rb", "test/test_cverror.rb", "test/test_cvfeaturetree.rb", "test/test_cvfont.rb", "test/test_cvhaarclassifiercascade.rb", "test/test_cvhistogram.rb", "test/test_cvhumoments.rb", "test/test_cvline.rb", "test/test_cvmat.rb", "test/test_cvmat_drawing.rb", "test/test_cvmat_dxt.rb", "test/test_cvmat_imageprocessing.rb", "test/test_cvmoments.rb", "test/test_cvpoint.rb", "test/test_cvpoint2d32f.rb", "test/test_cvpoint3d32f.rb", "test/test_cvrect.rb", "test/test_cvscalar.rb", "test/test_cvseq.rb", "test/test_cvsize.rb", "test/test_cvsize2d32f.rb", "test/test_cvslice.rb", "test/test_cvsurfparams.rb", "test/test_cvsurfpoint.rb", "test/test_cvtermcriteria.rb", "test/test_cvtwopoints.rb", "test/test_cvvideowriter.rb", "test/test_iplconvkernel.rb", "test/test_iplimage.rb", "test/test_mouseevent.rb", "test/test_opencv.rb", "test/test_pointset.rb", "test/test_preliminary.rb", "test/test_trackbar.rb", "test/test_window.rb"]
  s.homepage = "http://blueruby.mydns.jp/opencv"
  s.rdoc_options = ["--main", "README.rdoc"]
  s.require_paths = ["lib"]
  s.rubyforge_project = "opencv"
  s.rubygems_version = "1.8.15"
  s.summary = "OpenCV wrapper for Ruby."
  s.test_files = ["test/test_iplimage.rb", "test/test_curve.rb", "test/test_cvsurfparams.rb", "test/test_trackbar.rb", "test/test_cvline.rb", "test/test_iplconvkernel.rb", "test/test_cvbox2d.rb", "test/test_cvcircle32f.rb", "test/test_cvscalar.rb", "test/test_cvtermcriteria.rb", "test/test_cvhumoments.rb", "test/test_cvfont.rb", "test/test_cvsize2d32f.rb", "test/test_cvavgcomp.rb", "test/test_mouseevent.rb", "test/test_cvsurfpoint.rb", "test/test_preliminary.rb", "test/test_cvconnectedcomp.rb", "test/test_pointset.rb", "test/test_cvfeaturetree.rb", "test/test_cvpoint.rb", "test/test_cvmat_drawing.rb", "test/test_cvtwopoints.rb", "test/test_opencv.rb", "test/test_cvmat.rb", "test/test_cvcontour.rb", "test/test_cvseq.rb", "test/test_cverror.rb", "test/test_cvrect.rb", "test/test_cvcapture.rb", "test/test_cvhistogram.rb", "test/test_cvmoments.rb", "test/test_cvsize.rb", "test/test_window.rb", "test/test_cvvideowriter.rb", "test/test_cvpoint2d32f.rb", "test/test_cvhaarclassifiercascade.rb", "test/test_cvchain.rb", "test/test_cvmat_imageprocessing.rb", "test/test_cvcontourtree.rb", "test/test_cvmat_dxt.rb", "test/test_cvslice.rb", "test/test_cvpoint3d32f.rb"]

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<rake-compiler>, [">= 0"])
      s.add_development_dependency(%q<hoe-gemspec>, [">= 0"])
      s.add_development_dependency(%q<rspec>, [">= 0"])
      s.add_development_dependency(%q<rdoc>, ["~> 3.10"])
      s.add_development_dependency(%q<hoe>, ["~> 2.13"])
    else
      s.add_dependency(%q<rake-compiler>, [">= 0"])
      s.add_dependency(%q<hoe-gemspec>, [">= 0"])
      s.add_dependency(%q<rspec>, [">= 0"])
      s.add_dependency(%q<rdoc>, ["~> 3.10"])
      s.add_dependency(%q<hoe>, ["~> 2.13"])
    end
  else
    s.add_dependency(%q<rake-compiler>, [">= 0"])
    s.add_dependency(%q<hoe-gemspec>, [">= 0"])
    s.add_dependency(%q<rspec>, [">= 0"])
    s.add_dependency(%q<rdoc>, ["~> 3.10"])
    s.add_dependency(%q<hoe>, ["~> 2.13"])
  end
end
