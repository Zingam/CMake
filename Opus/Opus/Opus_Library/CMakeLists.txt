################################################################################
# Project: Opus
################################################################################

cmake_minimum_required (VERSION 3.10)

################################################################################
# Subroject variables
################################################################################

set (SubprojectName "Opus")
set (SubprojectVersion "0.1.0.0") # MAJOR.MINOR.PATCH.TWEAK
set (SubprojectURL "https://github.com/ShiftMediaProject/opus/releases/download/v1.2.1-2/libopus_v1.2.1-2_msvc15.zip")
set (SubprojectTargetNames "Opus")

# Only one of the variables DynamicLibraryName or StaticLibraryName can be 
# defined at the same time:
if (UseDynamicLibrary)
  set (DynamicLibraryName "opus")
else ()
  set (StaticLibraryName "libopus")
endif ()
set (HeaderName "opus/opus.h")

################################################################################
# This is a method to download, configure and build a library at configuration
# time
################################################################################

include ("__cmake/LibraryConfiguration.cmake")

################################################################################

