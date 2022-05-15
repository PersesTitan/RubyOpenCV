/************************************************************

   cvslice.cpp -

   $Author: lsxi $

   Copyright (C) 2005-2006 Masakazu Yonekura

************************************************************/
#include "cvslice.h"
/*
 * Document-class: OpenCV::CvClice
 *
 * C structure is here, very simple.
 *   typdef struct CvSlice {
 *     int start_index;
 *     int end_index;
 *   } CvSlice;
 */
__NAMESPACE_BEGIN_OPENCV
__NAMESPACE_BEGIN_CVSLICE

VALUE rb_klass;
    
VALUE
rb_class()
{
  return rb_klass;
}

void
define_ruby_class()
{
  if (rb_klass)
    return;
  /* 
   * opencv = rb_define_module("OpenCV");
   * 
   * note: this comment is used by rdoc.
   */
  VALUE opencv = rb_module_opencv();
  rb_klass = rb_define_class_under(opencv, "CvSlice", rb_cObject);
  rb_define_alloc_func(rb_klass, rb_allocate);
  rb_define_private_method(rb_klass, "initialize", RUBY_METHOD_FUNC(rb_initialize), 2);
  rb_define_method(rb_klass, "start_index", RUBY_METHOD_FUNC(rb_start_index_aref), 0);
  rb_define_method(rb_klass, "end_index", RUBY_METHOD_FUNC(rb_end_index_aref), 0);
  rb_define_method(rb_klass, "start_index=", RUBY_METHOD_FUNC(rb_start_index_aset), 1);
  rb_define_method(rb_klass, "end_index=", RUBY_METHOD_FUNC(rb_end_index_aset), 1);
}

VALUE
rb_allocate(VALUE klass)
{
  CvSlice *ptr;
  return Data_Make_Struct(klass, CvSlice, 0, -1, ptr);
}

/*
 * call-seq:
 *   new(<i>start, end</i>)
 *
 * Create new slice object.
 */
VALUE
rb_initialize(VALUE self, VALUE start, VALUE end)
{
  CvSlice *self_ptr = CVSLICE(self);
  self_ptr->start_index = NUM2INT(start);
  self_ptr->end_index = NUM2INT(end);
  return self;
}

/*
 * call-seq:
 *   start_index
 *
 */
VALUE
rb_start_index_aref(VALUE self)
{
  return INT2NUM(CVSLICE(self)->start_index);
}

/*
 * call-seq:
 *   end_index
 *
 */
VALUE
rb_end_index_aref(VALUE self)
{
  return INT2NUM(CVSLICE(self)->end_index);
}

/*
 * call-seq:
 *   start_index = index
 *
 */
VALUE
rb_start_index_aset(VALUE self, VALUE index)
{
  CVSLICE(self)->start_index = NUM2INT(index);
  return self;
}

/*
 * call-seq:
 *   end_index = index
 *
 */
VALUE
rb_end_index_aset(VALUE self, VALUE index)
{
  CVSLICE(self)->end_index = NUM2INT(index);
  return self;
}

__NAMESPACE_END_CVSLICE
__NAMESPACE_END_OPENCV
