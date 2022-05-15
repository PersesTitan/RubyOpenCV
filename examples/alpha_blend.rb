#!/usr/bin/env ruby
# -*- mode: ruby; coding: utf-8-unix -*-

# Alpha blending sample with GUI

require 'opencv'
include OpenCV

img1 = IplImage.load('lenna.jpg', CV_LOAD_IMAGE_ANYCOLOR | CV_LOAD_IMAGE_ANYDEPTH)
img2 = IplImage.load('tiffany.jpg', CV_LOAD_IMAGE_ANYCOLOR | CV_LOAD_IMAGE_ANYDEPTH)

window = GUI::Window.new('Alpha blend')
max = 100.0
val = max / 2.0
window.set_trackbar("Alpha", max, val) { |v|
  a = v.to_f / max
  window.show CvMat.add_weighted(img1, a, img2, 1.0 - a, 0)
}
window.show CvMat.add_weighted(img1, val / max, img2, 1.0 - val / max, 0)
GUI::wait_key

