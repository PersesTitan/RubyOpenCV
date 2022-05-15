#!/usr/bin/env ruby
# -*- mode: ruby; coding: utf-8-unix -*- 
require 'test/unit'
require 'opencv'
require File.expand_path(File.dirname(__FILE__)) + '/helper'

include OpenCV

# Tests for OpenCV::CvFeatureTree
class TestCvFeatureTree < OpenCVTestCase
  def test_initialize
    desc = CvMat.new(1, 1, :cv32f, 1)
    ft = CvFeatureTree.new(desc)
    assert_equal(CvFeatureTree, ft.class)
    
    assert_raise(TypeError) {
      CvFeatureTree.new(DUMMY_OBJ)
    }
  end

  def test_find_feature
    dim = 2
    points = []
    points << [99, 51]
    points << [52, 57]
    points << [57, 42]
    points << [13, 39]
    points << [15, 68]
    points << [75, 11]
    points << [69, 62]
    points << [52, 46]
    points << [0, 64]
    points << [67, 16]

    desc1 = CvMat.new(points.size, dim, :cv32f, 1)
    desc1.set_data(points)

    pt = [[50, 50], [11, 40]]
    desc2 = CvMat.new(pt.size, dim, :cv32f, 1)
    desc2.set_data(pt)

    ft = CvFeatureTree.new(desc1)
    results, dist = ft.find_features(desc2, 1, 10)

    assert_equal(CvMat, results.class)
    assert_equal(CvMat, dist.class)

    assert_equal(7, results[0][0].to_i)
    assert_in_delta(4.472, dist[0][0], 0.001)

    assert_equal(3, results[1][0].to_i)
    assert_in_delta(2.236, dist[1][0], 0.001)

    assert_raise(TypeError) {
      ft.find_features(DUMMY_OBJ, 1, 10)
    }
    assert_raise(TypeError) {
      ft.find_features(desc2, DUMMY_OBJ, 10)
    }
    assert_raise(TypeError) {
      ft.find_features(desc2, 1, DUMMY_OBJ)
    }
  end
end

