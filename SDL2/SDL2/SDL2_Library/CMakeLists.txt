################################################################################
# Project: SDL2
################################################################################

cmake_minimum_required (VERSION 3.10)

################################################################################
# Subroject variables
################################################################################

set (SubprojectName "SDL2")
set (SubprojectVersion "0.1.0.0") # MAJOR.MINOR.PATCH.TWEAK
set (SubprojectURL "https://www.libsdl.org/release/SDL2-2.0.7.zip")
set (SubprojectTargetNames "SDL2" "SDL2main")

################################################################################
# This is a method to download, configure and build a library at configuration
# time
################################################################################

include ("__cmake/LibraryConfiguration.cmake")

################################################################################

