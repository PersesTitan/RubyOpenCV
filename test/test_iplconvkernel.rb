#!/usr/bin/env ruby
# -*- mode: ruby; coding: utf-8-unix -*- 
require 'test/unit'
require 'opencv'
require File.expand_path(File.dirname(__FILE__)) + '/helper'

include OpenCV

# Tests for OpenCV::IplConvKernel
class TestIplConvKernel < OpenCVTestCase
  def test_initialize
    [:rect, :cross, :ellipse, CV_SHAPE_RECT, CV_SHAPE_CROSS, CV_SHAPE_ELLIPSE].each { |shape|
      kernel = IplConvKernel.new(5, 5, 2, 2, shape)
      assert_not_nil(kernel)
    }

    values = [1] * 25
    [:custom, CV_SHAPE_CUSTOM].each { |shape|
      kernel = IplConvKernel.new(5, 5, 2, 2, shape, values)
      assert_not_nil(kernel)
    }

    [:custom, CV_SHAPE_CUSTOM].each { |shape|
      assert_raise(ArgumentError) {
        IplConvKernel.new(5, 5, 2, 2, shape)
      }
    }

    assert_raise(TypeError) {
      IplConvKernel.new(5, 5, 2, 2, :foobar)
    }
  end

  def test_size
    kernel = IplConvKernel.new(5, 4, 2, 2, :rect)
    size = kernel.size
    assert_equal(5, size.width)
    assert_equal(4, size.height)

    assert_equal(5, kernel.cols)
    assert_equal(4, kernel.rows)
  end

  def test_anchor
    kernel = IplConvKernel.new(5, 4, 3, 2, :rect)
    a = kernel.anchor
    assert_equal(3, a.x)
    assert_equal(2, a.y)

    assert_equal(3, kernel.anchor_x)
    assert_equal(2, kernel.anchor_y)
  end
end

