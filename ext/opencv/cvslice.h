/************************************************************

   cvslice.h -

   $Author: lsxi $

   Copyright (C) 2005-2006 Masakazu Yonekura

************************************************************/
#ifndef RUBY_OPENCV_CVSLICE_H
#define RUBY_OPENCV_CVSLICE_H

#include "opencv.h"

#define __NAMESPACE_BEGIN_CVSLICE namespace cCvSlice {
#define __NAMESPACE_END_CVSLICE }

__NAMESPACE_BEGIN_OPENCV
__NAMESPACE_BEGIN_CVSLICE

VALUE rb_class();

void define_ruby_class();

VALUE rb_allocate(VALUE klass);
VALUE rb_initialize(VALUE self, VALUE start, VALUE end);
VALUE rb_start_index_aref(VALUE self);
VALUE rb_end_index_aref(VALUE self);
VALUE rb_start_index_aset(VALUE self, VALUE index);
VALUE rb_end_index_aset(VALUE self, VALUE index);

__NAMESPACE_END_CVSLICE

inline CvSlice*
CVSLICE(VALUE object)
{
  CvSlice *ptr;
  Data_Get_Struct(object, CvSlice, ptr);
  return ptr;
}

inline CvSlice
VALUE_TO_CVSLICE(VALUE object)
{
  if (rb_obj_is_kind_of(object, cCvSlice::rb_class())) {
    CvSlice* ptr = CVSLICE(object);
    return *ptr;
  }
  else if (rb_obj_is_kind_of(object, rb_cRange)) {
    return cvSlice(NUM2INT(rb_funcall(object, rb_intern("begin"), 0)),
                   rb_funcall(object, rb_intern("exclude_end?"), 0) ? NUM2INT(rb_funcall(object, rb_intern("end"), 0)) : NUM2INT(rb_funcall(object, rb_intern("end"), 0)) - 1);
  }
  else {
    raise_compatible_typeerror(object, cCvSlice::rb_class());
  }
  throw "Should never reach here";
}

__NAMESPACE_END_OPENCV

#endif // RUBY_OPENCV_CVSLICE_H
