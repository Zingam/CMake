################################################################################
# Project: Opus
################################################################################

cmake_minimum_required (VERSION 3.10)

################################################################################
# Subroject variables
################################################################################

set (ProjectName "Opus-Test")
set (ProjectVersion "0.1.0.0") # MAJOR.MINOR.PATCH.TWEAK

################################################################################
# Global properties
################################################################################
# Enable organization of targets into folders for capable CMake generators.
set_property (GLOBAL PROPERTY USE_FOLDERS ON)
################################################################################

project (${ProjectName} VERSION ${ProjectVersion})

################################################################################

add_subdirectory ("Opus_Library")
add_subdirectory ("Opus-Test")
