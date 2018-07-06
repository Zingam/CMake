################################################################################
cmake_minimum_required (VERSION 3.10)
################################################################################

################################################################################
# Local modules search path
################################################################################
list (APPEND CMAKE_MODULE_PATH "${CMAKE_CURRENT_LIST_DIR}/__cmake")
################################################################################

project ("CMakeModules")

find_package (OpenAL-Soft REQUIRED)
if (NOT OpenAL-Soft_FOUND)
  message ("ERROR: OpenAL-Soft SDK was not found in the search path!")
endif()

find_package (SDL2 REQUIRED)
if (NOT SDL2_FOUND)
  message ("ERROR: SDL2 SDK was not found in the search path!")
endif()

find_package (Steamworks REQUIRED)
if (NOT Steamworks_FOUND)
  message ("ERROR: Steamworks SDK was not found in the search path!")
endif()

add_executable (${PROJECT_NAME}
  "Source/main.cpp"
)
target_link_libraries (${PROJECT_NAME}
  REngine::OpenAL-Soft
  REngine::SDL2
  REngine::Steamworks
)
