################################################################################
# Project: WebM
################################################################################

cmake_minimum_required (VERSION 3.10)

################################################################################
# Subroject variables
################################################################################

set (SubprojectName "WebM")
set (SubprojectVersion "0.1.0.0") # MAJOR.MINOR.PATCH.TWEAK
set (SubprojectURL "https://github.com/webmproject/libwebm/archive/master.zip")
set (SubprojectTargetNames "webm")

# Tell WebM library that we use MSVC dynamic runtime libraries
set (MSVC_RUNTIME "dll")

################################################################################
# This is a method to download, configure and build a library at configuration
# time
################################################################################

include ("__cmake/LibraryConfiguration.cmake")

################################################################################

