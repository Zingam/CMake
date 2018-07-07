################################################################################
# Module: FindOpus
################################################################################
# Defines:
#   * Imported targets:
#       REngine::Opus
#   * Variables:
#       Opus_FOUND
#       Opus_INCLUDE_DIRS
#       Opus_LIBRARY
#       Opus_SHARED_LIBRARY
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

set (HeaderFile "opus/opus.h")
find_path (Opus_INCLUDE_DIR
  NAMES
    ${HeaderFile}
  PATHS
    "$ENV{IVENT_SOTS_EXTERNALIBS}/Opus"
  PATH_SUFFIXES
    "/include"
)
if (NOT Opus_INCLUDE_DIR)
  message (FATAL_ERROR "Unable to find header file: \"${HeaderFile}\"")
endif ()

################################################################################
# Library files
################################################################################

set (LibraryFile "opus")
find_library (Opus_LIBRARY
  NAMES
    ${LibraryFile}
  PATHS
    "$ENV{IVENT_SOTS_EXTERNALIBS}/Opus"
  PATH_SUFFIXES
    "/lib/${LibrarySearchPathSuffix}"
)
if (NOT Opus_LIBRARY)
  message (FATAL_ERROR "Unable to find library file: \"${LibraryFile}\"")
endif ()

if ("${CMAKE_SYSTEM_NAME}" STREQUAL "Windows")
  set (LibraryFile "${LibraryFile}.dll")
  find_file (Opus_SHARED_LIBRARY
    NAMES
      ${LibraryFile}
    PATHS
      "$ENV{IVENT_SOTS_EXTERNALIBS}/Opus"
    PATH_SUFFIXES
      "/bin/${LibrarySearchPathSuffix}"
  )
  # Hide internal implementation details from user
  set_property (CACHE Opus_SHARED_LIBRARY PROPERTY TYPE INTERNAL)
  if (NOT Opus_SHARED_LIBRARY)
    message (FATAL_ERROR "Unable to find library file: \"${LibraryFile}\"")
  endif ()
endif ()

################################################################################
# find_package arguments
################################################################################

include (FindPackageHandleStandardArgs)
find_package_handle_standard_args (Opus
  DEFAULT_MSG
    Opus_INCLUDE_DIR
    Opus_LIBRARY
    Opus_SHARED_LIBRARY
)
mark_as_advanced (
    Opus_INCLUDE_DIR
    Opus_LIBRARY
    Opus_SHARED_LIBRARY
)

################################################################################
# Imported target
################################################################################

if (Opus_FOUND AND NOT TARGET REngine::Opus)
  add_library (REngine::Opus UNKNOWN IMPORTED)
  set_target_properties (REngine::Opus
    PROPERTIES
      INTERFACE_INCLUDE_DIRECTORIES
        "${Opus_INCLUDE_DIR}"
      IMPORTED_LOCATION
        "${Opus_LIBRARY}"
  )
endif ()

################################################################################
