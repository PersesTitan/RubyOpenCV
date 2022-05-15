/************************************************************

   cvsurfpoint.h -

   $Author: ser1zw $

   Copyright (C) 2011 ser1zw

************************************************************/
#ifndef RUBY_OPENCV_CVSURFPOINT_H
#define RUBY_OPENCV_CVSURFPOINT_H

#include "opencv.h"

#define __NAMESPACE_BEGIN_CVSURFPOINT namespace cCvSURFPoint {
#define __NAMESPACE_END_CVSURFPOINT }

__NAMESPACE_BEGIN_OPENCV
__NAMESPACE_BEGIN_CVSURFPOINT

VALUE rb_class();

void define_ruby_class();

VALUE rb_allocate(VALUE klass);
VALUE rb_initialize(VALUE self, VALUE pt, VALUE laplacian, VALUE size, VALUE dir, VALUE hessian);
VALUE rb_get_pt(VALUE self);
VALUE rb_set_pt(VALUE self, VALUE value);
VALUE rb_get_laplacian(VALUE self);
VALUE rb_set_laplacian(VALUE self, VALUE value);
VALUE rb_get_size(VALUE self);
VALUE rb_set_size(VALUE self, VALUE value);
VALUE rb_get_dir(VALUE self);
VALUE rb_set_dir(VALUE self, VALUE value);
VALUE rb_get_hessian(VALUE self);
VALUE rb_set_hessian(VALUE self, VALUE value);

VALUE new_object(CvSURFPoint *cvsurfpoint);

__NAMESPACE_END_CVSURFPOINT

inline CvSURFPoint*
CVSURFPOINT(VALUE object)
{
  CvSURFPoint* ptr;
  Data_Get_Struct(object, CvSURFPoint, ptr);
  return ptr;
}

__NAMESPACE_END_OPENCV

#endif // RUBY_OPENCV_CVSURFPOINT_H
