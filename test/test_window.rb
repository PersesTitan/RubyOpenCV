#!/usr/bin/env ruby
# -*- mode: ruby; coding: utf-8-unix -*- 
require 'test/unit'
require 'opencv'
require File.expand_path(File.dirname(__FILE__)) + '/helper'

include OpenCV
include GUI

# Tests for OpenCV::Window
class TestWindow < OpenCVTestCase
  def setup
    @window1 = Window.new('window1')
    @window2 = Window.new('window2', CV_WINDOW_AUTOSIZE)
    @window3 = Window.new('window3', 0)
  end

  def teardown
    Window::destroy_all
  end
  
  def test_initialize
    [Window.new('w1'), Window.new('w2', CV_WINDOW_AUTOSIZE), Window.new('w3', 0)].each { |w|
      assert_not_nil(w)
      assert_equal(Window, w.class)
    }
    
    assert_raise(TypeError) {
      Window.new('w4', 'foobar')
    }

    assert_raise(StandardError) {
      Window.new('w5')
      Window.new('w5')
    }
  end

  def test_alive
    assert(@window1.alive?)
    @window1.destroy
    assert(!(@window1.alive?))
  end

  def test_destroy
    @window1.destroy
    assert(!(@window1.alive?))
  end

  def test_destroy_all
    Window::destroy_all
    assert(!(@window1.alive?))
    assert(!(@window2.alive?))
    assert(!(@window3.alive?))
  end

  def test_resize
    @window1.resize(CvSize.new(10, 20))
    @window2.resize(100, 200)
    assert_raise(ArgumentError) {
      @window3.resize
    }

    # Uncomment the following lines to show the results
    # @window1.show(CvMat.new(10, 20))
    # @window1.resize(100, 200)
    # GUI::wait_key
  end

  def test_move
    @window1.move(CvPoint.new(10, 20))
    @window2.move(100, 200)
    assert_raise(ArgumentError) {
      @window3.move
    }

    # Uncomment the following lines to show the results
    # @window1.show(CvMat.new(10, 20))
    # @window2.show(CvMat.new(100, 200))
    # GUI::wait_key
  end

  def test_show_image
    img = IplImage.load(FILENAME_CAT, CV_LOAD_IMAGE_ANYDEPTH | CV_LOAD_IMAGE_ANYCOLOR)
    @window1.show_image(img)
    @window2.show(img) # Alias

    # Uncomment the following lines to show the results
    # GUI::wait_key
  end

  def test_set_trackbar
    tr1 = @window1.set_trackbar('trackbar1', 100) { |value|
      puts value
    }
    assert_equal(Trackbar, tr1.class)

    trackbar2 = Trackbar.new('trackbar2', 10, 1) {}
    tr2 = @window2.set_trackbar(trackbar2)
    assert_equal(Trackbar, tr2.class)
  end

  def test_set_mouseevent
    @window1.set_mouse_callback { |mouse|
      e = "#{mouse.x}, #{mouse.y} : #{mouse.event} : "
      e << "<L>" if mouse.left_button?
      e << "<R>" if mouse.right_button?
      e << "<M>" if mouse.middle_button?
      e << "[CTRL]" if mouse.ctrl_key?
      e << "[SHIFT]" if mouse.shift_key?
      e << "[ALT]" if mouse.alt_key?
      puts e
    }
  end
end

