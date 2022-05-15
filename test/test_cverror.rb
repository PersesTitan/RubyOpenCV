#!/usr/bin/env ruby
# -*- mode: ruby; coding: utf-8-unix -*- 
require 'test/unit'
require 'opencv'
require File.expand_path(File.dirname(__FILE__)) + '/helper'

include OpenCV

# Tests for OpenCV::CvError
class TestCvError < OpenCVTestCase
  def test_cverror
    assert_equal(StandardError, CvError.superclass)
    begin
      raise CvError
    rescue
      assert_equal(CvError, $!.class)
    end
  end
  
  def test_subclass
    errors = [CvStsBackTrace, CvStsError, CvStsInternal, CvStsNoMem, CvStsBadArg, CvStsBadFunc, CvStsNoConv, CvStsAutoTrace, CvHeaderIsNull, CvBadImageSize, CvBadOffset, CvBadDataPtr, CvBadStep, CvBadModelOrChSeq, CvBadNumChannels, CvBadNumChannel1U, CvBadDepth, CvBadAlphaChannel, CvBadOrder, CvBadOrigin, CvBadAlign, CvBadCallBack, CvBadTileSize, CvBadCOI, CvBadROISize, CvMaskIsTiled, CvStsNullPtr, CvStsVecLengthErr, CvStsFilterStructContentErr, CvStsKernelStructContentErr, CvStsFilterOffsetErr, CvStsBadSize, CvStsDivByZero, CvStsInplaceNotSupported, CvStsObjectNotFound, CvStsUnmatchedFormats, CvStsBadFlag, CvStsBadPoint, CvStsBadMask, CvStsUnmatchedSizes, CvStsUnsupportedFormat, CvStsOutOfRange, CvStsParseError, CvStsNotImplemented, CvStsBadMemBlock, CvStsAssert, CvGpuNotSupported, CvGpuApiCallError, CvGpuNppCallError, CvGpuCufftCallError]

    errors.each { |err|
      assert_equal(CvError, err.superclass)

      begin
        raise err
      rescue err
        assert_equal(err, $!.class)
      rescue
        flunk("Failed to catch #{err}")
      end

      begin
        raise err
      rescue CvError
        assert_equal(err, $!.class)
      rescue
        flunk("Failed to catch #{err}")
      end

      begin
        raise err
      rescue
        assert_equal(err, $!.class)
      end
    }
  end
end

