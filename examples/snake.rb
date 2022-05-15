#!/usr/bin/env ruby
# snake.rb
require "rubygems"
require "opencv"
include OpenCV

puts <<USAGE
usage:
  left-click: set a point
  right-click: do snake
USAGE

window = GUI::Window.new "snake demo"
image = CvMat.new(256, 256, :cv8u, 1).clear!
image.circle!(CvPoint.new(128,128), 40, :color => CvColor::White, :thickness => -1)
display = image.GRAY2BGR

window.show display

points = []

window.on_mouse{|mouse|
  case mouse.event
  when :left_button_down
    display.circle!(mouse, 1, :color => CvColor::Red, :thickness => 2)
    puts "set point (#{mouse.x},#{mouse.y})"
    points << CvPoint.new(mouse.x, mouse.y)
    window.show display
  when :right_button_down
    if points.length < 3
      puts "please set more point!"
      next
    end
    snake_points = image.snake_image(points, 1.0, 0.5, 1.5, CvSize.new(3, 3), 100)
    display = image.GRAY2BGR
    display.poly_line!([snake_points], :color => CvColor::Red, :is_closed => true, :thickness => 2)
    window.show display
    points.clear
  end
}

GUI::wait_key

