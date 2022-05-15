#!/usr/bin/env ruby
# -*- mode: ruby; coding: utf-8-unix -*- 
require 'test/unit'
require 'opencv'
require File.expand_path(File.dirname(__FILE__)) + '/helper'

include OpenCV

# Tests for OpenCV::CvSlice
class TestCvSlice < OpenCVTestCase
  def setup
    @slice = CvSlice.new(2, 4)
  end

  def test_initialize
    assert_equal(CvSlice, @slice.class)
  end

  def test_start_index
    assert_equal(2, @slice.start_index)
    @slice.start_index = 3
    assert_equal(3, @slice.start_index)
  end

  def test_end_index
    assert_equal(4, @slice.end_index)
    @slice.end_index = 5
    assert_equal(5, @slice.end_index)
  end
end

