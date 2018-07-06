################################################################################
# Module: FindLibVPX
################################################################################
# Defines:
#   * Imported targets:
#       REngine::LibVPX
#   * Variables:
#       LibVPX_FOUND
#       LibVPX_INCLUDE_DIRS
#       LibVPX_LIBRARIES
################################################################################

# Search path suffix corresponding to the platform
set (LibrarySearchPathSuffix "x")

# Append bitness to the search path suffix
if ("${CMAKE_SIZEOF_VOID_P}" STREQUAL "8")
  set (LibrarySearchPathSuffix "${LibrarySearchPathSuffix}64")
elseif ("${CMAKE_SIZEOF_VOID_P}" STREQUAL "4")
  set (LibrarySearchPathSuffix "${LibrarySearchPathSuffix}32")
else ()
  message (FATAL_ERROR "Unsupported architecture: ${CMAKE_SIZEOF_VOID_P} bit")
endif ()

set (HeaderFile "vpx/vp8.h")
find_path (LibVPX_INCLUDE_DIR
  NAMES
    ${HeaderFile}
  PATHS
    "$ENV{IVENT_SOTS_EXTERNALIBS}/LibVPX"
  PATH_SUFFIXES
    "/include"
)
if (NOT LibVPX_INCLUDE_DIR)
  message (FATAL_ERROR "Unable to find header file: \"${HeaderFile}\"")
endif ()

set (LibraryFile "vpx")
find_library (LibVPX_LIBRARY
  NAMES
    ${LibraryFile}
  PATHS
    "$ENV{IVENT_SOTS_EXTERNALIBS}/LibVPX"
  PATH_SUFFIXES
    "/lib/${LibrarySearchPathSuffix}"
)
if (NOT LibVPX_LIBRARY)
  message (FATAL_ERROR "Unable to find library file: \"${LibraryFile}\"")
endif ()

include (FindPackageHandleStandardArgs)
find_package_handle_standard_args (LibVPX
  DEFAULT_MSG
    LibVPX_LIBRARY
    LibVPX_INCLUDE_DIR
)
mark_as_advanced (
    LibVPX_LIBRARY 
    LibVPX_INCLUDE_DIR
)

if (LibVPX_FOUND AND NOT TARGET REngine::LibVPX)
  add_library (REngine::LibVPX UNKNOWN IMPORTED)
  set_target_properties (REngine::LibVPX
    PROPERTIES
      INTERFACE_INCLUDE_DIRECTORIES
        "${LibVPX_INCLUDE_DIR}"
      IMPORTED_LOCATION
        "${LibVPX_LIBRARY}"
  )
endif ()
