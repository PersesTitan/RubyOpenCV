/************************************************************

   cvfont.h -

   $Author: lsxi $

   Copyright (C) 2005-2006 Masakazu Yonekura

************************************************************/
#ifndef RUBY_OPENCV_CVFONT_H
#define RUBY_OPENCV_CVFONT_H

#include "opencv.h"

#define __NAMESPACE_BEGIN_CVFONT namespace cCvFont {
#define __NAMESPACE_END_CVFONT }

__NAMESPACE_BEGIN_OPENCV
__NAMESPACE_BEGIN_CVFONT

#define FONT_OPTION(op) rb_get_option_table(rb_klass, "FONT_OPTION", op)
#define FO_ITALIC(op) TRUE_OR_FALSE(LOOKUP_CVMETHOD(op, "italic"))
#define FO_HSCALE(op) NUM2DBL(LOOKUP_CVMETHOD(op, "hscale"))
#define FO_VSCALE(op) NUM2DBL(LOOKUP_CVMETHOD(op, "vscale"))
#define FO_SHEAR(op) NUM2DBL(LOOKUP_CVMETHOD(op, "shear"))
#define FO_THICKNESS(op) NUM2INT(LOOKUP_CVMETHOD(op, "thickness"))
#define FO_LINE_TYPE(op) rb_font_option_line_type(op)

VALUE rb_class();

void define_ruby_class();

VALUE rb_allocate(VALUE klass);
VALUE rb_initialize(int argc, VALUE *argv, VALUE self);

VALUE rb_face(VALUE self);
VALUE rb_hscale(VALUE self);
VALUE rb_vscale(VALUE self);
VALUE rb_shear(VALUE self);
VALUE rb_thickness(VALUE self);
VALUE rb_line_type(VALUE self);
VALUE rb_italic(VALUE self);

__NAMESPACE_END_CVFONT

inline CvFont*
CVFONT(VALUE object)
{
  CvFont *ptr;
  Data_Get_Struct(object, CvFont, ptr);
  return ptr;
}

inline CvFont*
CVFONT_WITH_CHECK(VALUE object)
{
  if (!rb_obj_is_kind_of(object, cCvFont::rb_class()))
    raise_typeerror(object, cCvFont::rb_class());
  return CVFONT(object);
}

__NAMESPACE_END_OPENCV

#endif // RUBY_OPENCV_CVFONT_H
