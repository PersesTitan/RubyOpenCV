#!/usr/bin/env ruby
# -*- mode: ruby; coding: utf-8-unix -*- 
require 'test/unit'
require 'opencv'
require File.expand_path(File.dirname(__FILE__)) + '/helper'

include OpenCV

# Tests for OpenCV::CvHistogram
class TestCvHistogram < OpenCVTestCase
  def setup
    @img = IplImage.load(FILENAME_LENA32x32, 0)

    dim = 1
    sizes = [8]
    ranges = [[0, 255]]
    @hist1 = CvHistogram.new(dim, sizes, CV_HIST_ARRAY, ranges, true).calc_hist!([@img])

    dim = 2
    sizes = [8, 16]
    ranges = [[0, 255], [0, 255]]
    @hist2 = CvHistogram.new(dim, sizes, CV_HIST_SPARSE, ranges, true).calc_hist!([@img, @img])
  end

  def teardown
    @hist1 = nil
    @hist2 = nil
    GC.start
  end

  def test_initialize
    dim = 1
    sizes = [256]
    ranges = [[0, 256]]
    hist1 = CvHistogram.new(dim, sizes, CV_HIST_ARRAY, ranges, true)
    hist2 = CvHistogram.new(dim, sizes, CV_HIST_ARRAY)
    hist3 = CvHistogram.new(dim, sizes, CV_HIST_ARRAY, nil)
    hist4 = CvHistogram.new(dim, sizes, CV_HIST_ARRAY, nil, false)
  end

  def test_is_uniform
    assert(@hist1.is_uniform?)
    assert(@hist2.is_uniform?)
  end

  def test_is_sparse
    assert_false(@hist1.is_sparse?)
    assert(@hist2.is_sparse?)
  end

  def test_has_range
    assert(@hist1.has_range?)
    assert(@hist2.has_range?)
  end

  def test_calc_hist
    img = IplImage.new(1, 1, :cv8u, 1)
    assert_equal(CvHistogram, @hist1.calc_hist([img]).class)
    assert_equal(CvHistogram, @hist1.calc_hist([img, img]).class)
    assert_equal(CvHistogram, @hist1.calc_hist([img], true).class)
    assert_equal(CvHistogram, @hist1.calc_hist([img, img], false).class)
    mask = CvMat.new(1, 1, :cv8u, 1)
    assert_equal(CvHistogram, @hist1.calc_hist([img], true, mask).class)

    assert_raise(TypeError) {
      @hist1.calc_hist(img)
    }
    assert_raise(TypeError) {
      @hist1.calc_hist([DUMMY_OBJ])
    }
    assert_raise(TypeError) {
      @hist1.calc_hist(nil)
    }
    assert_raise(TypeError) {
      @hist1.calc_hist([img], true, DUMMY_OBJ)
    }
    assert_raise(CvStsBadArg) {
      @hist1.calc_hist([])
    }
  end

  def test_aref
    expected = [0.0, 102.0, 189.0, 244.0, 285.0, 140.0, 64.0, 0.0]
    expected.each_with_index { |x, i|
      assert_in_delta(x, @hist1[i], 0.001)
      assert_in_delta(x, @hist1.query_hist_value(i), 0.001)
    }
  end

  def test_min_max_value
    min, max, min_loc, max_loc = @hist1.min_max_value
    assert_in_delta(0.0, min, 0.001)
    assert_in_delta(285.0, max, 0.001)
    assert_equal(Array, min_loc.class)
    assert_equal(Array, max_loc.class)
    assert_equal(1, min_loc.size)
    assert_equal(1, max_loc.size)
    assert_equal(0, min_loc[0])
    assert_equal(4, max_loc[0])

    min, max, min_loc, max_loc = @hist2.min_max_value
    assert_in_delta(14.0, min, 0.001)
    assert_in_delta(158.0, max, 0.001)
    assert_equal(Array, min_loc.class)
    assert_equal(Array, max_loc.class)
    assert_equal(2, min_loc.size)
    assert_equal(2, max_loc.size)
    assert_equal(1, min_loc[0])
    assert_equal(2, min_loc[1])
    assert_equal(4, max_loc[0])
    assert_equal(9, max_loc[1])
  end

  def test_dims
    dims, sizes = @hist1.dims
    assert_equal(1, dims)
    assert_equal(Array, sizes.class)
    assert_equal(1, sizes.size)
    assert_equal(8, sizes[0])

    dims, sizes = @hist2.dims
    assert_equal(2, dims)
    assert_equal(Array, sizes.class)
    assert_equal(2, sizes.size)
    assert_equal(8, sizes[0])
    assert_equal(16, sizes[1])
  end

  def test_copy_hist
    expected = [0.0, 102.0, 189.0, 244.0, 285.0, 140.0, 64.0, 0.0]
    hist = @hist1.copy_hist
    expected.each_with_index { |x, i|
      assert_in_delta(x, hist[i], 0.001)
      assert_in_delta(x, hist.query_hist_value(i), 0.001)
    }
  end

  def test_clear_hist
    @hist1.clear_hist!
    dims, sizes = @hist1.dims
    dims.times { |i|
      assert_in_delta(0.0, @hist1[i], 0.001)
    }
  end

  def test_normalize_hist
    @hist1.normalize_hist!(100)
    expected = [0.0, 9.96, 18.46, 23.83, 27.83, 13.67, 6.25, 0.0]
    expected.each_with_index { |x, i|
      assert_in_delta(x, @hist1[i], 0.01)
    }
  end

  def test_thresh_hist
    @hist1.thresh_hist!(150)
    expected = [0.0, 0.0, 189.0, 244.0, 285.0, 0.0, 0.0, 0.0]
    expected.each_with_index { |x, i|
      assert_in_delta(x, @hist1[i], 0.001)
    }
  end

  def test_set_hist_bin_ranges
    dim = 1
    sizes = [8]

    hist = CvHistogram.new(dim, sizes, CV_HIST_ARRAY)
    assert_false(hist.has_range?)
    assert(hist.is_uniform?)

    ranges = [[0, 255]]    
    hist.set_hist_bin_ranges!(ranges, true)
    assert(hist.has_range?)
    assert(hist.is_uniform?)

    assert_raise(TypeError) {
      hist.set_hist_bin_ranges!(DUMMY_OBJ)
    }
    assert_raise(TypeError) {
      hist.set_hist_bin_ranges!([DUMMY_OBJ])
    }
  end

  def test_calc_back_project
    back_project = @hist1.calc_back_project([@img])
    assert_equal(@img.class, back_project.class)
    assert_equal('2a0097af1ab4f9343e4feaae3a780c93', hash_img(back_project))

    assert_raise(TypeError) {
      @hist1.calc_back_project(DUMMY_OBJ)
    }
    assert_raise(TypeError) {
      @hist1.calc_back_project([DUMMY_OBJ])
    }
  end

  def test_calc_back_project_patch
    img = IplImage.load(FILENAME_LENA256x256, 0)
    template = IplImage.load(FILENAME_LENA_EYES, 0)

    dim = 1
    sizes = [8]
    ranges = [[0, 255]]
    hist = CvHistogram.new(dim, sizes, CV_HIST_ARRAY, ranges).calc_hist!([template])
    back_project = hist.calc_back_project_patch([img], template.size, CV_COMP_CORREL, 1.0)
    assert_equal('e6497e45c6f2f715328bbc2fefe31581', hash_img(back_project))

    assert_raise(TypeError) {
      hist.calc_back_project_patch(DUMMY_OBJ, template.size, CV_COMP_CORREL, 1.0)
    }
    assert_raise(TypeError) {
      hist.calc_back_project_patch([DUMMY_OBJ], template.size, CV_COMP_CORREL, 1.0)
    }

    # Uncomment the following line to show the result
    # min_val, max_val, min_loc, max_loc = back_project.min_max_loc
    # result = img.rectangle(max_loc, CvPoint.new(max_loc.x + template.width, max_loc.y + template.height),
    #                        :thickness => 2)
    # snap img, template, back_project, result
  end

  def test_compare_hist
    img = IplImage.load(FILENAME_CAT, 0)
    dim, sizes = @hist1.dims
    ranges = [[0, 255]]
    hist = CvHistogram.new(dim, sizes, CV_HIST_ARRAY, ranges).calc_hist!([img])

    assert_in_delta(0.7446, CvHistogram.compare_hist(@hist1, hist, CV_COMP_CORREL), 0.001)
    assert_in_delta(184459.0, CvHistogram.compare_hist(@hist1, hist, CV_COMP_CHISQR), 1.0)
    assert_in_delta(1024.0, CvHistogram.compare_hist(@hist1, hist, CV_COMP_INTERSECT), 1.0)
    assert_in_delta(0.2955, CvHistogram.compare_hist(@hist1, hist, CV_COMP_BHATTACHARYYA), 0.001)

    assert_raise(TypeError) {
      CvHistogram.compare_hist(DUMMY_OBJ, hist, CV_COMP_CORREL)
    }
    assert_raise(TypeError) {
      CvHistogram.compare_hist(@hist1, DUMMY_OBJ, CV_COMP_CORREL)
    }
    assert_raise(TypeError) {
      CvHistogram.compare_hist(@hist1, hist, DUMMY_OBJ)
    }
  end

  def test_calc_prob_density
    img = IplImage.load(FILENAME_CAT, 0)
    dim, sizes = @hist1.dims
    ranges = [[0, 255]]
    hist = CvHistogram.new(dim, sizes, CV_HIST_ARRAY, ranges).calc_hist!([img])
    dst = CvHistogram.calc_prob_density(hist, @hist1)

    assert_equal(CvHistogram, dst.class)
    dim, sizes = dst.dims
    expected_dim, expected_sizes = @hist1.dims
    assert_equal(expected_dim, dim)
    expected_sizes.each_with_index { |x, i|
      assert_equal(x, sizes[i])
    }

    expected = [0.0, 1.437, 1.135, 1.092, 2.323, 3.712, 3.103, 0.0]
    expected.each_with_index { |x, i|
      assert_in_delta(x, dst[i], 0.001)
    }

    assert_raise(TypeError) {
      CvHistogram.calc_prob_density(DUMMY_OBJ, @hist1)
    }
    assert_raise(TypeError) {
      CvHistogram.calc_prob_density(hist, DUMMY_OBJ)
    }
  end
end

