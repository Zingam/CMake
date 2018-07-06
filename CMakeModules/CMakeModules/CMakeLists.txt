################################################################################
cmake_minimum_required (VERSION 3.10)
################################################################################

################################################################################
# Local modules search path
################################################################################
list (APPEND CMAKE_MODULE_PATH "${CMAKE_CURRENT_LIST_DIR}/__cmake")
################################################################################

project ("CMakeModules")

find_package (LibVPX REQUIRED)
if (NOT LibVPX_FOUND)
  message ("ERROR: LibVPX SDK was not found in the search path!")
endif()

find_package (OpenAL-Soft REQUIRED)
if (NOT OpenAL-Soft_FOUND)
  message ("ERROR: OpenAL-Soft SDK was not found in the search path!")
endif()

find_package (Opus REQUIRED)
if (NOT Opus_FOUND)
  message ("ERROR: Opus SDK was not found in the search path!")
endif()

find_package (SDL2 REQUIRED)
if (NOT SDL2_FOUND)
  message ("ERROR: SDL2 SDK was not found in the search path!")
endif()

find_package (Steamworks REQUIRED)
if (NOT Steamworks_FOUND)
  message ("ERROR: Steamworks SDK was not found in the search path!")
endif()

find_package (Vorbis REQUIRED)
if (NOT Vorbis_FOUND)
  message ("ERROR: Vorbis SDK was not found in the search path!")
endif()

add_executable (${PROJECT_NAME}
  "Source/main.cpp"
)
target_link_libraries (${PROJECT_NAME}
  REngine::LibVPX
  REngine::OpenAL-Soft
  REngine::Opus
  REngine::SDL2
  REngine::Steamworks
  REngine::Vorbis
)
