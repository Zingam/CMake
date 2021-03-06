################################################################################
cmake_minimum_required (VERSION 3.10)
################################################################################

################################################################################
# Local modules search path
################################################################################
list (APPEND CMAKE_MODULE_PATH "${CMAKE_CURRENT_LIST_DIR}/__cmake")
################################################################################

################################################################################
# Project name
################################################################################
project ("CMakeModules")
################################################################################

################################################################################
# External precompiled libraries
################################################################################
find_package (LibVPX REQUIRED)
if (NOT LibVPX_FOUND)
  message ("ERROR: LibVPX SDK was not found in the search path!")
endif()
list (APPEND SharedLibraries ${LibVPX_SHARED_LIBRARY})

find_package (OpenAL-Soft REQUIRED)
if (NOT OpenAL-Soft_FOUND)
  message ("ERROR: OpenAL-Soft SDK was not found in the search path!")
endif()
list (APPEND SharedLibraries ${OpenAL-Soft_SHARED_LIBRARY})

find_package (Opus REQUIRED)
if (NOT Opus_FOUND)
  message ("ERROR: Opus SDK was not found in the search path!")
endif()
list (APPEND SharedLibraries ${Opus_SHARED_LIBRARY})

find_package (SDL2 REQUIRED)
if (NOT SDL2_FOUND)
  message ("ERROR: SDL2 SDK was not found in the search path!")
endif()
list (APPEND SharedLibraries ${SDL2_SHARED_LIBRARY})

find_package (Steamworks REQUIRED)
if (NOT Steamworks_FOUND)
  message ("ERROR: Steamworks SDK was not found in the search path!")
endif()
list (APPEND SharedLibraries ${Steamworks_SHARED_LIBRARIES})

find_package (Vorbis REQUIRED)
if (NOT Vorbis_FOUND)
  message ("ERROR: Vorbis SDK was not found in the search path!")
endif()
list (APPEND SharedLibraries ${Vorbis_SHARED_LIBRARY})

################################################################################
# External online libraries
#   These libraries will be downloaded from the Internet and configured
################################################################################
option (option_DownloadLibrariesLocally NO)
if (option_DownloadLibrariesLocally)
  set (WebM_URL "$ENV{IVENT_SOTS_EXTERNALIBS}/WebM/master.zip")
endif ()
add_subdirectory ("__cmake/Libraries/WebM_Library")

################################################################################
# Project target
################################################################################
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
    WebM_Library
)

################################################################################
# Install
################################################################################
message ("Shared libraries to install:")
foreach (SharedLibrary ${SharedLibraries})
  message ("    ${SharedLibrary}")
endforeach ()

set (InstallationFolder "${CMAKE_INSTALL_PREFIX}")
get_filename_component (InstallationFolder
  "${InstallationFolder}" ABSOLUTE
)
install (TARGETS ${PROJECT_NAME}
  RUNTIME DESTINATION "${InstallationFolder}"
)
install (
  FILES
    ${SharedLibraries}
    "Media/steam_appid.txt"
    "Media/sample.webm"
  DESTINATION "${InstallationFolder}"
)
################################################################################
