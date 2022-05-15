#!/usr/bin/env ruby
# -*- mode: ruby; coding: utf-8-unix -*- 
require 'test/unit'
require 'opencv'
require File.expand_path(File.dirname(__FILE__)) + '/helper'

include OpenCV

# Tests for OpenCV::CvHaarClassifierCascade
class TestCvHaarClassifierCascade < OpenCVTestCase
  def setup
    @cascade = CvHaarClassifierCascade.load(HAARCASCADE_FRONTALFACE_ALT)
  end

  def test_load
    assert_equal(CvHaarClassifierCascade, @cascade.class)
    assert_raise(ArgumentError) {
      CvHaarClassifierCascade.load('not/exist.xml')
    }
  end
  
  def test_detect_objects
    img = CvMat.load(FILENAME_LENA256x256)

    detected = @cascade.detect_objects(img)
    assert_equal(CvSeq, detected.class)
    assert_equal(1, detected.size)
    assert_equal(CvAvgComp, detected[0].class)
    assert_equal(106, detected[0].x)
    assert_equal(100, detected[0].y)
    assert_equal(89, detected[0].width)
    assert_equal(89, detected[0].height)
    assert_equal(48, detected[0].neighbors)

    detected = @cascade.detect_objects(img) { |face|
      assert_equal(106, face.x)
      assert_equal(100, face.y)
      assert_equal(89, face.width)
      assert_equal(89, face.height)
      assert_equal(48, face.neighbors)
    }
    assert_equal(CvSeq, detected.class)
    assert_equal(1, detected.size)
    assert_equal(CvAvgComp, detected[0].class)

    detected = @cascade.detect_objects(img, :scale_factor => 2.0, :flags => CV_HAAR_DO_CANNY_PRUNING,
                                       :min_neighbors => 5, :min_size => CvSize.new(10, 10),
                                       :max_size => CvSize.new(100, 100))
    assert_equal(CvSeq, detected.class)
    assert_equal(1, detected.size)
    assert_equal(CvAvgComp, detected[0].class)
    assert_equal(109, detected[0].x)
    assert_equal(102, detected[0].y)
    assert_equal(80, detected[0].width)
    assert_equal(80, detected[0].height)
    assert_equal(7, detected[0].neighbors)

    assert_raise(TypeError) {
      @cascade.detect_objects('foo')
    }
  end
end

