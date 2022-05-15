#!/usr/bin/env ruby
=begin
create Makefile script for Ruby/OpenCV

usage : ruby extconf.rb
        make && make install

VC : ruby extconf.rb
     nmake
	 nmake install
=end
require "mkmf"

dir_config("opencv", "/usr/local/include", "/usr/local/lib")
dir_config("libxml2", "/usr/include", "/usr/lib")

opencv_headers = ["opencv2/core/core_c.h", "opencv2/core/core.hpp", "opencv2/imgproc/imgproc_c.h",
                  "opencv2/imgproc/imgproc.hpp", "opencv2/video/tracking.hpp", "opencv2/features2d/features2d.hpp",
                  "opencv2/flann/flann.hpp", "opencv2/calib3d/calib3d.hpp", "opencv2/objdetect/objdetect.hpp",
                  "opencv2/legacy/compat.hpp", "opencv2/legacy/legacy.hpp", "opencv2/highgui/highgui_c.h",
                  "opencv2/highgui/highgui.hpp"]

opencv_libraries = ["opencv_calib3d", "opencv_contrib", "opencv_core", "opencv_features2d",
                    "opencv_flann", "opencv_gpu", "opencv_highgui", "opencv_imgproc",
                    "opencv_legacy", "opencv_ml", "opencv_objdetect", "opencv_video"]


puts ">> Check the required libraries..."

OPENCV_VERSION_SUFFIX = '231'
case CONFIG["arch"]
when /mswin32/
  opencv_libraries.map! {|lib| lib + OPENCV_VERSION_SUFFIX }
  have_library("msvcrt")
  opencv_libraries.each {|lib|
    raise "#{lib}.lib not found." unless have_library(lib)
  }
  $CFLAGS << ' /EHsc'
when /mingw32/
  opencv_libraries.map! {|lib| lib + OPENCV_VERSION_SUFFIX }
  have_library("msvcrt")
  opencv_libraries.each {|lib|
    raise "lib#{lib} not found." unless have_library(lib)
  }
else
  opencv_libraries.each {|lib|
    raise "lib#{lib} not found." unless have_library(lib)
  }
  have_library("stdc++")
end

# Check the required headers
puts ">> Check the required headers..."
opencv_headers.each {|header|
  raise "#{header} not found." unless have_header(header)
}
have_header("stdarg.h")

# Quick fix for 1.8.7
$CFLAGS << " -I#{File.dirname(__FILE__)}/ext/opencv"

# Create Makefile
create_makefile("opencv", "./ext/opencv")

