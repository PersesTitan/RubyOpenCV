/************************************************************

   cvfeaturetree.h -

   $Author: ser1zw $

   Copyright (C) 2011 ser1zw

************************************************************/
#ifndef RUBY_OPENCV_CVFEATURETREE_H
#define RUBY_OPENCV_CVFEATURETREE_H

#include "opencv.h"

#define __NAMESPACE_BEGIN_CVFEATURETREE namespace cCvFeatureTree {
#define __NAMESPACE_END_CVFEATURETREE }

__NAMESPACE_BEGIN_OPENCV
__NAMESPACE_BEGIN_CVFEATURETREE

VALUE rb_class();
void define_ruby_class();
VALUE rb_allocate(VALUE klass);
VALUE rb_initialize(VALUE self, VALUE desc);
VALUE rb_find_features(VALUE self, VALUE desc, VALUE k, VALUE emax);

__NAMESPACE_END_CVFEATURETREE

typedef struct _CvFeatureTreeWrap {
  CvFeatureTree* feature_tree;
  VALUE desc;
} CvFeatureTreeWrap;

inline CvFeatureTree*
CVFEATURETREE(VALUE object)
{
  CvFeatureTreeWrap* ptr;
  Data_Get_Struct(object, CvFeatureTreeWrap, ptr);
  return ptr->feature_tree;
}

inline CvFeatureTree*
CVFEATURETREE_WITH_CHECK(VALUE object)
{
  if (!rb_obj_is_kind_of(object, cCvFeatureTree::rb_class()))
    raise_typeerror(object, cCvFeatureTree::rb_class());
  return CVFEATURETREE(object);
}

__NAMESPACE_END_OPENCV

#endif // RUBY_OPENCV_CVFEATURETREE



