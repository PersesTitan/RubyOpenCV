/************************************************************

   cvscalar.h -

   $Author: lsxi $

   Copyright (C) 2005 Masakazu Yonekura

************************************************************/
#ifndef RUBY_OPENCV_CVSCALAR_H
#define RUBY_OPENCV_CVSCALAR_H

#include "opencv.h"

#define __NAMESPACE_BEGIN_CVSCALAR namespace cCvScalar {
#define __NAMESPACE_END_CVSCALAR }

__NAMESPACE_BEGIN_OPENCV
__NAMESPACE_BEGIN_CVSCALAR

VALUE rb_class();

void define_ruby_class();

VALUE rb_compatible_q(VALUE klass, VALUE object);

VALUE rb_allocate(VALUE klass);
VALUE rb_initialize(int argc, VALUE *argv, VALUE self);

VALUE rb_aref(VALUE self, VALUE index);
VALUE rb_aset(VALUE self, VALUE index, VALUE value);
VALUE rb_sub(int argc, VALUE *argv, VALUE self);

VALUE rb_to_s(VALUE self);
VALUE rb_to_ary(VALUE self);

VALUE new_object();
VALUE new_object(CvScalar scalar);

__NAMESPACE_END_CVSCALAR

inline CvScalar*
CVSCALAR(VALUE object)
{
  CvScalar *ptr;
  Data_Get_Struct(object, CvScalar, ptr);
  return ptr;
}

inline CvScalar
VALUE_TO_CVSCALAR(VALUE object)
{
  ID aref_id;
  if (FIXNUM_P(object)) {
    return cvScalarAll(FIX2INT(object));
  }
  else if (rb_respond_to(object, (aref_id = rb_intern("[]")))) {
    return cvScalar(NUM2DBL(rb_funcall(object, aref_id, 1, INT2FIX(0))),
		    NUM2DBL(rb_funcall(object, aref_id, 1, INT2FIX(1))),
		    NUM2DBL(rb_funcall(object, aref_id, 1, INT2FIX(2))),
		    NUM2DBL(rb_funcall(object, aref_id, 1, INT2FIX(3))));
  }
  else {
    raise_compatible_typeerror(object, cCvScalar::rb_class());
  }
  throw "Should never reach here";
}

__NAMESPACE_END_OPENCV

#endif // RUBY_OPENCV_CVSCALAR_H
