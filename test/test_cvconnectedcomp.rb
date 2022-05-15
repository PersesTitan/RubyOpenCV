#!/usr/bin/env ruby
# -*- mode: ruby; coding: utf-8-unix -*- 
require 'test/unit'
require 'opencv'
require File.expand_path(File.dirname(__FILE__)) + '/helper'

include OpenCV

# Tests for OpenCV::CvConnectedComp
class TestCvConnectedComp < OpenCVTestCase
  def setup
    @connected_comp = CvConnectedComp.new(9216, CvScalar.new(1, 2, 3, 4),
                                          CvRect.new(1, 2, 3, 4), CvSeq.new(CvPoint))
  end
  
  def test_initialize
    connected_comp = CvConnectedComp.new
    assert_equal(CvConnectedComp, connected_comp.class)
    assert_not_nil(connected_comp.area)
    assert_not_nil(connected_comp.value)
    assert_not_nil(connected_comp.rect)
    assert_not_nil(connected_comp.contour)

    connected_comp = CvConnectedComp.new(100, CvScalar.new(1, 2, 3, 4),
                                         CvRect.new(1, 2, 3, 4), CvSeq.new(CvPoint))
    assert_equal(CvConnectedComp, connected_comp.class)
    assert_not_nil(connected_comp.area)
    assert_not_nil(connected_comp.value)
    assert_not_nil(connected_comp.rect)
    assert_not_nil(connected_comp.contour)
  end

  def test_area
    assert_in_delta(9216.0, @connected_comp.area, 0.01)
  end

  def test_value
    assert_equal(CvScalar, @connected_comp.value.class)
    assert_cvscalar_equal(CvScalar.new(1, 2, 3, 4), @connected_comp.value)
  end

  def test_rect
    assert_equal(CvRect, @connected_comp.rect.class)
    assert_equal(1, @connected_comp.rect.x)
    assert_equal(2, @connected_comp.rect.y)
    assert_equal(3, @connected_comp.rect.width)
    assert_equal(4, @connected_comp.rect.height)

    @connected_comp.rect = CvRect.new(10, 20, 30, 40);
    assert_equal(10, @connected_comp.rect.x)
    assert_equal(20, @connected_comp.rect.y)
    assert_equal(30, @connected_comp.rect.width)
    assert_equal(40, @connected_comp.rect.height)
  end

  def test_contour
    assert_equal(CvContour, @connected_comp.contour.class)
    assert_not_nil(@connected_comp.contour)
  end
end

