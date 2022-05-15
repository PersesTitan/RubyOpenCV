/************************************************************

   cvsurfparams.h -

   $Author: ser1zw $

   Copyright (C) 2011 ser1zw

************************************************************/
#ifndef RUBY_OPENCV_CVSURFPARAMS_H
#define RUBY_OPENCV_CVSURFPARAMS_H

#include "opencv.h"

#define __NAMESPACE_BEGIN_CVSURFPARAMS namespace cCvSURFParams {
#define __NAMESPACE_END_CVSURFPARAMS }

__NAMESPACE_BEGIN_OPENCV
__NAMESPACE_BEGIN_CVSURFPARAMS

VALUE rb_class();

void define_ruby_class();

VALUE rb_allocate(VALUE klass);
VALUE rb_initialize(int argc, VALUE *argv, VALUE self);
VALUE rb_get_hessian_threshold(VALUE self);
VALUE rb_set_hessian_threshold(VALUE self, VALUE value);
VALUE rb_get_extended(VALUE self);
VALUE rb_set_extended(VALUE self, VALUE value);
VALUE rb_get_n_octaves(VALUE self);
VALUE rb_set_n_octaves(VALUE self, VALUE value);
VALUE rb_get_n_octave_layers(VALUE self);
VALUE rb_set_n_octave_layers(VALUE self, VALUE value);

VALUE new_object(CvSURFPoint *cvsurfparams);

__NAMESPACE_END_CVSURFPARAMS

inline CvSURFParams*
CVSURFPARAMS(VALUE object)
{
  CvSURFParams* ptr;
  Data_Get_Struct(object, CvSURFParams, ptr);
  return ptr;
}

inline CvSURFParams*
CVSURFPARAMS_WITH_CHECK(VALUE object)
{
  if (!rb_obj_is_kind_of(object, cCvSURFParams::rb_class()))
    raise_typeerror(object, cCvSURFParams::rb_class());
  return CVSURFPARAMS(object);
}

__NAMESPACE_END_OPENCV

#endif // RUBY_OPENCV_CVSURFPARAMS_H
