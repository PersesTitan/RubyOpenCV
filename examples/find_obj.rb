#!/usr/bin/env ruby
# -*- mode: ruby; coding: utf-8-unix -*- 

# A Demo Ruby/OpenCV Implementation of SURF
# See https://code.ros.org/trac/opencv/browser/tags/2.3.1/opencv/samples/c/find_obj.cpp
require 'opencv'
require 'benchmark'
include OpenCV

def compare_surf_descriptors(d1, d2, best, length)
  raise ArgumentError unless (length % 4) == 0
  total_cost = 0
  0.step(length - 1, 4) { |i|
    t0 = d1[i] - d2[i]
    t1 = d1[i + 1] - d2[i + 1]
    t2 = d1[i + 2] - d2[i + 2]
    t3 = d1[i + 3] - d2[i + 3]
    total_cost += t0 * t0 + t1 * t1 + t2 * t2 + t3 * t3
    break if total_cost > best
  }
  total_cost
end

def naive_nearest_neighbor(vec, laplacian, model_keypoints, model_descriptors)
  length = model_descriptors[0].size
  neighbor = nil
  dist1 = 1e6
  dist2 = 1e6

  model_descriptors.size.times { |i|
    kp = model_keypoints[i]
    mvec = model_descriptors[i]
    next if laplacian != kp.laplacian
    
    d = compare_surf_descriptors(vec, mvec, dist2, length)
    if d < dist1
      dist2 = dist1
      dist1 = d
      neighbor = i
    elsif d < dist2
      dist2 = d
    end
  }

  return (dist1 < 0.6 * dist2) ? neighbor : nil
end

def find_pairs(object_keypoints, object_descriptors,
               image_keypoints, image_descriptors)
  ptpairs = []
  object_descriptors.size.times { |i|
    kp = object_keypoints[i]
    descriptor = object_descriptors[i]
    nearest_neighbor = naive_nearest_neighbor(descriptor, kp.laplacian, image_keypoints, image_descriptors)
    unless nearest_neighbor.nil?
      ptpairs << i
      ptpairs << nearest_neighbor
    end
  }
  ptpairs
end

def locate_planar_object(object_keypoints, object_descriptors,
                         image_keypoints, image_descriptors, src_corners)
  ptpairs = find_pairs(object_keypoints, object_descriptors, image_keypoints, image_descriptors)
  n = ptpairs.size / 2
  return nil if n < 4

  pt1 = []
  pt2 = []
  n.times { |i|
    pt1 << object_keypoints[ptpairs[i * 2]].pt
    pt2 << image_keypoints[ptpairs[i * 2 + 1]].pt
  }

  _pt1 = CvMat.new(1, n, CV_32F, 2)
  _pt2 = CvMat.new(1, n, CV_32F, 2)
  _pt1.set_data(pt1)
  _pt2.set_data(pt2)
  h = CvMat.find_homography(_pt1, _pt2, :ransac, 5)

  dst_corners = []
  4.times { |i|
    x = src_corners[i].x
    y = src_corners[i].y
    z = 1.0 / (h[6][0] * x + h[7][0] * y + h[8][0])
    x = (h[0][0] * x + h[1][0] * y + h[2][0]) * z
    y = (h[3][0] * x + h[4][0] * y + h[5][0]) * z
    dst_corners << CvPoint.new(x.to_i, y.to_i)
  }

  dst_corners
end


##### Main #####
puts 'This program demonstrated the use of the SURF Detector and Descriptor using'
puts 'brute force matching on planar objects.'
puts 'Usage:'
puts "ruby #{__FILE__} <object_filename> <scene_filename>, default is box.png and box_in_scene.png"
puts

object_filename = (ARGV.size == 2) ? ARGV[0] : 'box.png'
scene_filename = (ARGV.size == 2) ? ARGV[1] : 'box_in_scene.png'

object, image = nil, nil
begin
  object = IplImage.load(object_filename, CV_LOAD_IMAGE_GRAYSCALE)
  image = IplImage.load(scene_filename, CV_LOAD_IMAGE_GRAYSCALE)
rescue
  puts "Can not load #{object_filename} and/or #{scene_filename}"
  puts "Usage: ruby #{__FILE__} [<object_filename> <scene_filename>]"
  exit
end
object_color = object.GRAY2BGR

param = CvSURFParams.new(1500)

object_keypoints, object_descriptors = nil, nil
image_keypoints, image_descriptors = nil, nil
tms = Benchmark.measure {
  object_keypoints, object_descriptors = object.extract_surf(param)
  puts "Object Descriptors: #{object_descriptors.size}"

  image_keypoints, image_descriptors = image.extract_surf(param)
  puts "Image Descriptors: #{image_descriptors.size}"
}
puts "Extraction time = #{tms.real * 1000} ms"

correspond = IplImage.new(image.width, object.height + image.height, CV_8U, 1);
correspond.set_roi(CvRect.new(0, 0, object.width, object.height))
object.copy(correspond)
correspond.set_roi(CvRect.new(0, object.height, image.width, image.height))
image.copy(correspond)
correspond.reset_roi

src_corners = [CvPoint.new(0, 0), CvPoint.new(object.width, 0),
               CvPoint.new(object.width, object.height), CvPoint.new(0, object.height)]
dst_corners = locate_planar_object(object_keypoints, object_descriptors,
                                   image_keypoints, image_descriptors, src_corners)

correspond = correspond.GRAY2BGR
if dst_corners
  4.times { |i|
    r1 = dst_corners[i % 4]
    r2 = dst_corners[(i + 1) % 4]
    correspond.line!(CvPoint.new(r1.x, r1.y + object.height), CvPoint.new(r2.x, r2.y + object.height),
                     :color => CvColor::Red, :thickness => 2, :line_type => :aa)
  }
end

ptpairs = find_pairs(object_keypoints, object_descriptors, image_keypoints, image_descriptors)

0.step(ptpairs.size - 1, 2) { |i|
  r1 = object_keypoints[ptpairs[i]]
  r2 = image_keypoints[ptpairs[i + 1]]
  correspond.line!(r1.pt, CvPoint.new(r2.pt.x, r2.pt.y + object.height),
                   :color => CvColor::Red, :line_type => :aa)
}

object_keypoints.each { |r|
  radius = (r.size * 1.2 / 9.0 * 2).to_i
  object_color.circle!(r.pt, radius, :color => CvColor::Red, :line_type => :aa)
}

GUI::Window.new('Object Correspond').show correspond
GUI::Window.new('Object').show object_color
GUI::wait_key

