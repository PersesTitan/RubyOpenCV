/************************************************************

   window.h -

   $Author: lsxi $

   Copyright (C) 2005-2006 Masakazu Yonekura

************************************************************/
#ifndef RUBY_OPENCV_GUI_H
#include "gui.h"
#endif

#ifndef RUBY_OPENCV_GUI_WINDOW_H
#define RUBY_OPENCV_GUI_WINDOW_H

#include "opencv.h"
#define __NAMESPACE_BEGIN_WINDOW namespace cWindow {
#define __NAMESPACE_END_WINDOW }

__NAMESPACE_BEGIN_OPENCV
__NAMESPACE_BEGIN_GUI

typedef struct Window {
  VALUE name;
  VALUE image;
  VALUE trackbars;
  VALUE blocks;
} Window;

__NAMESPACE_BEGIN_WINDOW

void define_ruby_class();

VALUE rb_allocate(VALUE klass);

void window_mark(void *ptr);
void window_free(void *ptr);
VALUE rb_alive_q(VALUE self);
VALUE rb_initialize(int argc, VALUE *argv, VALUE self);
VALUE rb_destroy(VALUE self);
VALUE rb_destroy_all(VALUE klass);
VALUE rb_resize(int argc, VALUE *argv, VALUE self);
VALUE rb_move(int argc, VALUE *argv, VALUE self);
VALUE rb_show_image(VALUE self, VALUE img);
VALUE rb_set_trackbar(int argc, VALUE *argv, VALUE self);
VALUE rb_set_mouse_callback(int argc, VALUE* argv, VALUE self);

inline Window*
WINDOW(VALUE object) {
  Window *ptr;
  Data_Get_Struct(object, Window, ptr);
  return ptr;
}

inline const char*
GET_WINDOW_NAME(VALUE object) {
  return StringValueCStr(WINDOW(object)->name);
}

__NAMESPACE_END_WINDOW
__NAMESPACE_END_GUI
__NAMESPACE_END_OPENCV

#endif // RUBY_OPENCV_GUI_WINDOW_H

