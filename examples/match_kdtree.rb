#!/usr/bin/env ruby
# -*- mode: ruby; coding: utf-8-unix -*- 

# A sample of matching SURF feature points using kd-tree
# See http://tech.groups.yahoo.com/group/OpenCV/message/62318

require 'opencv'
include OpenCV

USE_EXTENDED_DESCRIPTOR = true
THRESHOLD = 1500
DESCRIPTOR_SIZE = USE_EXTENDED_DESCRIPTOR ? 128 : 64

img1 = CvMat.load('lenna.jpg', CV_LOAD_IMAGE_GRAYSCALE)
img2 = CvMat.load('lenna-rotated.jpg', CV_LOAD_IMAGE_GRAYSCALE)

puts 'Extracting features from img1 using SURF...'
param = CvSURFParams.new(THRESHOLD, USE_EXTENDED_DESCRIPTOR)
kp1, desc1 = img1.extract_surf(param)
puts "found #{kp1.size} keypoints from img1"

puts 'Extracting features from img2 using SURF...'
kp2, desc2 = img2.extract_surf(param)
puts "found #{kp2.size} keypoints from img2"

puts 'Matching keypoints...'
desc1mat = CvMat.new(kp1.size, DESCRIPTOR_SIZE, :cv32f, 1)
desc2mat = CvMat.new(kp2.size, DESCRIPTOR_SIZE, :cv32f, 1)
desc1.each_with_index { |desc, i|
  desc.each_with_index { |d, j|
    desc1mat[i, j] = CvScalar.new(d)
  }
}
desc2.each_with_index { |desc, i|
  desc.each_with_index { |d, j|
    desc2mat[i, j] = CvScalar.new(d)
  }
}

feature_tree = CvFeatureTree.new(desc1mat)
results, distances = feature_tree.find_features(desc2mat, 1, 250)

reverse_lookup = []
reverse_lookup_dist = []
kp1.size.times { |i|
  reverse_lookup << -1
  reverse_lookup_dist << Float::MAX
}

match_count = 0
kp2.size.times { |j|
  i = results[j][0].to_i
  d = distances[j][0]
  if (d < reverse_lookup_dist[i])
    match_count += 1 if reverse_lookup_dist[i] == Float::MAX
    reverse_lookup[i] = j
    reverse_lookup_dist[i] = d
  end
}
puts "found #{match_count} putative correspondences"

points1 = []
points2 = []
kp2.size.times { |j|
  i = results[j][0].to_i
  if (j == reverse_lookup[i])
    points1 << kp1[i].pt
    points2 << kp2[j].pt
  end
}

width = img1.cols + img2.cols
height = (img1.rows > img2.rows) ? img1.rows : img2.rows
correspond = IplImage.new(width, height, :cv8u, 1);
correspond.set_roi(CvRect.new(0, 0, img1.cols, img1.rows))
img1.copy(correspond)
correspond.set_roi(CvRect.new(img1.cols, 0, img1.cols + img2.cols, img2.rows))
img2.copy(correspond)
correspond.reset_roi

points1.zip(points2) { |pt1, pt2|
  pt2.x += img1.cols
  correspond.line!(pt1, pt2, :color => CvColor::White)
}

GUI::Window.new('Object Correspond').show correspond
GUI::wait_key

