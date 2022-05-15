#!/usr/bin/env ruby
# -*- mode: ruby; coding: utf-8-unix -*- 
require 'test/unit'
require 'opencv'
require File.expand_path(File.dirname(__FILE__)) + '/helper'

include OpenCV

# Tests for OpenCV::Curve
class TestCurve < OpenCVTestCase
  def setup
    @contour1 = CvContour.new
    
    mat0 = create_cvmat(128, 128, :cv8u, 1) { |j, i|
      (j - 64) ** 2 + (i - 64) ** 2 <= (32 ** 2) ? CvColor::White : CvColor::Black
    }
    @contour2 = mat0.find_contours
  end

  def test_closed
    assert_false(@contour1.closed?)
    assert(@contour2.closed?)
  end

  def test_convex
    assert_false(@contour1.convex?)
  end

  def test_hole
    assert_false(@contour1.hole?)
  end

  def test_simple
    assert(@contour1.simple?)
  end

  def test_arc_length
    assert_in_delta(211.480, @contour2.arc_length, 0.001)
    assert_in_delta(18.071, @contour2.arc_length(CvSlice.new(0, 9), true), 0.001)
    assert_in_delta(18.071, @contour2.arc_length(0..10, true), 0.001)
  end
end

