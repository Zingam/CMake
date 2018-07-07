################################################################################
# Module: FindVorbis
################################################################################
# Defines:
#   * Imported targets:
#       REngine::Vorbis
#   * Variables:
#       Vorbis_FOUND
#       Vorbis_INCLUDE_DIRS
#       Vorbis_LIBRARY
#       Vorbis_SHARED_LIBRARY
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

set (HeaderFile "vorbis/codec.h")
find_path (Vorbis_INCLUDE_DIR
  NAMES
    ${HeaderFile}
  PATHS
    "$ENV{IVENT_SOTS_EXTERNALIBS}/Vorbis"
  PATH_SUFFIXES
    "/include"
)
if (NOT Vorbis_INCLUDE_DIR)
  message (FATAL_ERROR "Unable to find header file: \"${HeaderFile}\"")
endif ()

################################################################################
# Library files
################################################################################

set (LibraryFile "vorbis")
find_library (Vorbis_LIBRARY
  NAMES
    ${LibraryFile}
  PATHS
    "$ENV{IVENT_SOTS_EXTERNALIBS}/Vorbis"
  PATH_SUFFIXES
    "/lib/${LibrarySearchPathSuffix}"
)
if (NOT Vorbis_LIBRARY)
  message (FATAL_ERROR "Unable to find library file: \"${LibraryFile}\"")
endif ()

if ("${CMAKE_SYSTEM_NAME}" STREQUAL "Windows")
  set (LibraryFile "${LibraryFile}.dll")
  find_file (Vorbis_SHARED_LIBRARY
    NAMES
      ${LibraryFile}
    PATHS
      "$ENV{IVENT_SOTS_EXTERNALIBS}/Vorbis"
    PATH_SUFFIXES
      "/bin/${LibrarySearchPathSuffix}"
  )
  # Hide internal implementation details from user
  set_property (CACHE Vorbis_SHARED_LIBRARY PROPERTY TYPE INTERNAL)
  if (NOT Vorbis_SHARED_LIBRARY)
    message (FATAL_ERROR "Unable to find library file: \"${LibraryFile}\"")
  endif ()
endif ()

################################################################################
# find_package arguments
################################################################################

include (FindPackageHandleStandardArgs)
find_package_handle_standard_args (Vorbis
  DEFAULT_MSG
    Vorbis_INCLUDE_DIR
    Vorbis_LIBRARY
    Vorbis_SHARED_LIBRARY
)
mark_as_advanced (
    Vorbis_INCLUDE_DIR
    Vorbis_LIBRARY
    Vorbis_SHARED_LIBRARY
)

################################################################################
# Imported target
################################################################################

if (Vorbis_FOUND AND NOT TARGET REngine::Vorbis)
  add_library (REngine::Vorbis UNKNOWN IMPORTED)
  set_target_properties (REngine::Vorbis
    PROPERTIES
      INTERFACE_INCLUDE_DIRECTORIES
        "${Vorbis_INCLUDE_DIR}"
      IMPORTED_LOCATION
        "${Vorbis_LIBRARY}"
  )
endif ()

################################################################################
