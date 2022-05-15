#!/usr/bin/env ruby
# -*- mode: ruby; coding: utf-8-unix -*- 
require 'test/unit'
require 'opencv'
require File.expand_path(File.dirname(__FILE__)) + '/helper'

include OpenCV

# Tests for OpenCV::CvAvgComp
class TestCvAvgComp < OpenCVTestCase
  def setup
    @avgcomp = CvAvgComp.new
  end

  def test_initialize
    assert_equal(CvAvgComp, @avgcomp.class)
    assert(@avgcomp.is_a? CvRect)
  end

  def test_neighbors
    assert_equal(Fixnum, @avgcomp.neighbors.class)
  end
end

