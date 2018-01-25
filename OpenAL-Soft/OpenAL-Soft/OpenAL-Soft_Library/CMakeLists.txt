################################################################################
# Project: SDL2
################################################################################

cmake_minimum_required (VERSION 3.10)

################################################################################
# Subroject variables
################################################################################

set (SubprojectName "OpenAL-Soft")
set (SubprojectVersion "0.1.0.0") # MAJOR.MINOR.PATCH.TWEAK
set (SubprojectURL "https://github.com/kcat/openal-soft/archive/master.zip")
set (SubprojectTargetNames "OpenAL" "common")

################################################################################
# This is a method to download, configure and build a library at configuration
# time
################################################################################

include ("__cmake/LibraryConfiguration.cmake")

################################################################################

