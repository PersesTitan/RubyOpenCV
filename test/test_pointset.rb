#!/usr/bin/env ruby
# -*- mode: ruby; coding: utf-8-unix -*- 
require 'test/unit'
require 'opencv'
require File.expand_path(File.dirname(__FILE__)) + '/helper'

include OpenCV

# Tests for OpenCV::PointSet
class TestPointSet < OpenCVTestCase
  def setup
    mat0 = create_cvmat(128, 128, :cv8u, 1) { |j, i|
      (j - 64) ** 2 + (i - 64) ** 2 <= (32 ** 2) ? CvColor::White : CvColor::Black
    }
    @contour1 = mat0.find_contours
    @contour2 = CvContour.new
  end

  def test_contour_area
    assert_equal(3118, @contour1.contour_area.to_i)
    
    s = CvSlice.new(0, @contour1.size / 2)
    assert_equal(1527, @contour1.contour_area(s).to_i)

    assert_raise(TypeError) {
      @contour1.contour_area(DUMMY_OBJ)
    }
    assert_raise(CvStsBadArg) {
      @contour2.contour_area
    }
  end

  def test_fit_ellipse2
    box = @contour1.fit_ellipse2

    center = box.center
    assert_equal(64, center.x.to_i)
    assert_equal(64, center.y.to_i)

    size = box.size
    assert_in_delta(63.116, size.width, 0.001)
    assert_in_delta(63.116, size.height, 0.001)
    assert_in_delta(180, box.angle, 0.001)

    assert_raise(CvStsBadArg) {
      @contour2.fit_ellipse2
    }
  end

  def test_convex_hull2
    [@contour1.convex_hull2, @contour1.convex_hull2(true)].each { |hull|
      assert_equal(36, hull.size)
      assert_equal(CvContour, hull.class)
      assert_equal(CvPoint, hull[0].class)
      assert_equal(32, hull[0].x)
      assert_equal(64, hull[0].y)
    }

    hull = @contour1.convex_hull2(false)
    assert_equal(36, hull.size)
    assert_equal(CvContour, hull.class)
    assert_equal(CvPoint, hull[0].class)
    assert_equal(96, hull[0].x)
    assert_equal(64, hull[0].y)

    @contour1.convex_hull2(DUMMY_OBJ)
  end

  def test_check_contour_convexity
    assert_false(@contour1.check_contour_convexity)
  end

  def test_convexity_defects
    flunk('FIXME: Currently PointSet#convexity_defects does not work well.')
    hull = @contour1.convex_hull2(true, false)
    defects = @contour1.convexity_defects(hull)
    puts defects.class
    puts defects[0].start.to_a.join(', ')
    assert_equal(CvSeq, defects.class)
    assert_equal(CvConvexityDefect, defects[0].class)
  end

  def test_min_area_rect2
    box = @contour1.min_area_rect2

    assert_equal(CvBox2D, box.class)
    center = box.center
    assert_equal(64, center.x.to_i)
    assert_equal(64, center.y.to_i)

    size = box.size
    assert_in_delta(63.356, size.width, 0.001)
    assert_in_delta(63.356, size.height, 0.001)
    assert_in_delta(-8.130, box.angle, 0.001)

    flunk('FIXME: Currently PointSet#min_area_rect2 causes segmentation fault when "self" is invalid.')    
    assert_raise(CvStsBadSize) {
      @contour2.min_area_rect2
    }
  end

  def test_min_enclosing_circle
    circle = @contour1.min_enclosing_circle
    assert_equal(CvCircle32f, circle.class)
    center = circle.center
    assert_equal(64, center.x.to_i)
    assert_equal(64, center.y.to_i)
    assert_in_delta(32.959, circle.radius, 0.001)

    assert_raise(CvStsBadArg) {
      @contour2.min_enclosing_circle
    }
  end

  def test_calc_pgh
    flunk('FIXME: PointSet#calc_pgh is not implemented yet.')
  end
end

