/************************************************************

   cverror.h -

   $Author: lsxi $

   Copyright (C) 2005-2006 Masakazu Yonekura

************************************************************/
#ifndef RUBY_OPENCV_CVERROR_H
#define RUBY_OPENCV_CVERROR_H

#include "opencv.h"

#define __NAMESPACE_BEGIN_CVERROR namespace cCvError {
#define __NAMESPACE_END_CVERROR }

__NAMESPACE_BEGIN_OPENCV
__NAMESPACE_BEGIN_CVERROR

void define_ruby_class();
VALUE by_code(int error_code);
void raise(cv::Exception e);

__NAMESPACE_END_CVERROR
__NAMESPACE_END_OPENCV

#endif // RUBY_OPENCV_CVERROR_H
