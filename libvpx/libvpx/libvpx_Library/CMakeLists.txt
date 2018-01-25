################################################################################
# Project: libvpx
################################################################################

cmake_minimum_required (VERSION 3.10)

################################################################################
# Subroject variables
################################################################################

set (SubprojectName "libvpx")
set (SubprojectVersion "0.1.0.0") # MAJOR.MINOR.PATCH.TWEAK
set (SubprojectURL "https://github.com/ShiftMediaProject/libvpx/releases/download/v1.6.1-3/libvpx_v1.6.1-3_msvc15.zip")
set (SubprojectTargetNames "libvpx")

# Only one of the variables DynamicLibraryName or StaticLibraryName can be 
# defined at the same time:
if (UseDynamicLibrary)
  set (DynamicLibraryName "vpx")
else ()
  set (StaticLibraryName "libvpx")
endif ()
set (HeaderName "vpx/vpx_codec.h")

################################################################################
# This is a method to download, configure and build a library at configuration
# time
################################################################################

include ("__cmake/LibraryConfiguration.cmake")

################################################################################
