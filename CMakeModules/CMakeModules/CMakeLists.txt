################################################################################
cmake_minimum_required (VERSION 3.10)
################################################################################

################################################################################
# Local modules search path
################################################################################
list (APPEND CMAKE_MODULE_PATH "${CMAKE_CURRENT_LIST_DIR}/__cmake")
################################################################################

project ("CMakeModules")

find_package (Steamworks REQUIRED)
if (NOT Steamworks_FOUND)
  message ("ERROR: Steamworks SDK was not found in the search path!")
endif()
