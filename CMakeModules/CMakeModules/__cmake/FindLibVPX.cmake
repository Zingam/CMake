################################################################################
# Module: FindLibVPX
################################################################################
# Defines:
#   * Imported targets:
#       REngine::LibVPX
#   * Variables:
#       LibVPX_FOUND
#       LibVPX_INCLUDE_DIRS
#       LibVPX_LIBRARY
#       LibVPX_SHARED_LIBRARY
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

################################################################################
# Header files
################################################################################

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

################################################################################
# Library files
################################################################################

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

if ("${CMAKE_SYSTEM_NAME}" STREQUAL "Windows")
  set (LibraryFile "${LibraryFile}.dll")
  find_file (LibVPX_SHARED_LIBRARY
    NAMES
      ${LibraryFile}
    PATHS
      "$ENV{IVENT_SOTS_EXTERNALIBS}/LibVPX"
    PATH_SUFFIXES
      "/bin/${LibrarySearchPathSuffix}"
  )
  # Hide internal implementation details from user
  set_property (CACHE LibVPX_SHARED_LIBRARY PROPERTY TYPE INTERNAL)
  if (NOT LibVPX_SHARED_LIBRARY)
    message (FATAL_ERROR "Unable to find library file: \"${LibraryFile}\"")
  endif ()
endif ()

################################################################################
# find_package arguments
################################################################################

include (FindPackageHandleStandardArgs)
find_package_handle_standard_args (LibVPX
  DEFAULT_MSG
    LibVPX_INCLUDE_DIR
    LibVPX_LIBRARY
    LibVPX_SHARED_LIBRARY
)
mark_as_advanced (
    LibVPX_INCLUDE_DIR
    LibVPX_LIBRARY
    LibVPX_SHARED_LIBRARY
)

################################################################################
# Imported target
################################################################################

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

################################################################################
