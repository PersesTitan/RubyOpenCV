#!/usr/bin/env ruby
# houghcircle.rb
require "rubygems"
require "opencv"
include OpenCV

original_window = GUI::Window.new "original"
hough_window = GUI::Window.new "hough circles"

image = IplImage::load "stuff.jpg"
gray = image.BGR2GRAY

result = image.clone
original_window.show image
detect = gray.hough_circles(CV_HOUGH_GRADIENT, 2.0, 10, 200, 50)
puts detect.size
detect.each{|circle|
  puts "#{circle.center.x},#{circle.center.y} - #{circle.radius}"
  result.circle! circle.center, circle.radius, :color => CvColor::Red, :thickness => 3
}
hough_window.show result
GUI::wait_key
