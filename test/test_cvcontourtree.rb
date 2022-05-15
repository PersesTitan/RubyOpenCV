#!/usr/bin/env ruby
# -*- mode: ruby; coding: utf-8-unix -*- 
require 'test/unit'
require 'opencv'
require File.expand_path(File.dirname(__FILE__)) + '/helper'

include OpenCV

# Tests for OpenCV::CvContourTree
class TestCvContourTree < OpenCVTestCase
  def setup
    @tree = CvContourTree.new(CvPoint)
  end

  def test_initialize
    tree = CvContourTree.new(CvPoint)
    assert_equal(CvContourTree, tree.class)
    assert(tree.is_a? CvSeq)
  end

  def test_p1
    assert_equal(CvPoint, @tree.p1.class)
  end

  def test_p2
    assert_equal(CvPoint, @tree.p2.class)
  end

  def test_contour
    mat0 = create_cvmat(128, 128, :cv8u, 1) { |j, i|
      (j - 64) ** 2 + (i - 64) ** 2 <= (32 ** 2) ? CvColor::White : CvColor::Black
    }
    contour = mat0.find_contours
    tree = contour.create_tree
    contour = tree.contour(CvTermCriteria.new(100, 0.01))
    assert_equal(CvContour, contour.class)

    assert_raise(CvStsBadArg) {
      tree.contour(CvTermCriteria.new(0, 0))
    }
  end
end

