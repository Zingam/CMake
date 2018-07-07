################################################################################
# Module: FindOpenAL-Soft
################################################################################
# Defines:
#   * Imported targets:
#       REngine::OpenAL-Soft
#   * Variables:
#       OpenAL-Soft_FOUND
#       OpenAL-Soft_INCLUDE_DIRS
#       OpenAL-Soft_LIBRARY
################################################################################

# Search path suffix corresponding to the platform
if ("${CMAKE_SYSTEM_NAME}" STREQUAL "Windows")
  set (LibrarySearchPathSuffix "Win")
elseif ("${CMAKE_SYSTEM_NAME}" STREQUAL "Linux")
  set (LibrarySearchPathSuffix "linux")
elseif ("${CMAKE_SYSTEM_NAME}" STREQUAL "Darwin")
  set (LibrarySearchPathSuffix "osx")
else ()
  if (CMAKE_SYSTEM_NAME)
    set (ErrorMessage "Unsupported system - ${CMAKE_SYSTEM_NAME}")
  else ()
    # CMAKE_SYSTEM_NAME will be set if "find_package" command is used after a 
    # "project" command
    set (ErrorMessage
      "CMAKE_SYSTEM_NAME is not set. The target system is not yet defined.
       Use \"find_package\" after a \"project\" command."
    )
  endif ()
  message (FATAL_ERROR "  --> ERROR: ${ErrorMessage}")
endif ()

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

set (HeaderFile "AL/al.h")
find_path (OpenAL-Soft_INCLUDE_DIR
  NAMES
    ${HeaderFile}
  PATHS
    "$ENV{IVENT_SOTS_EXTERNALIBS}/OpenAL-Soft"
  PATH_SUFFIXES
    "/include"
)
if (NOT OpenAL-Soft_INCLUDE_DIR)
  message (FATAL_ERROR "Unable to find header file: \"${HeaderFile}\"")
endif ()

################################################################################
# Library files
################################################################################

set (LibraryFile "OpenAL32")
find_library (OpenAL-Soft_LIBRARY
  NAMES
    ${LibraryFile}
  PATHS
    "$ENV{IVENT_SOTS_EXTERNALIBS}/OpenAL-Soft"
  PATH_SUFFIXES
    "/libs/${LibrarySearchPathSuffix}"
)
if (NOT OpenAL-Soft_LIBRARY)
  message (FATAL_ERROR "Unable to find library file: \"${LibraryFile}\"")
endif ()

################################################################################
# find_package arguments
################################################################################

include (FindPackageHandleStandardArgs)
find_package_handle_standard_args (OpenAL-Soft
  DEFAULT_MSG
    OpenAL-Soft_LIBRARY
    OpenAL-Soft_INCLUDE_DIR
)
mark_as_advanced (
    OpenAL-Soft_LIBRARY 
    OpenAL-Soft_INCLUDE_DIR
)

################################################################################
# Imported target
################################################################################

if (OpenAL-Soft_FOUND AND NOT TARGET REngine::OpenAL-Soft)
  add_library (REngine::OpenAL-Soft UNKNOWN IMPORTED)
  set_target_properties (REngine::OpenAL-Soft
    PROPERTIES
      INTERFACE_INCLUDE_DIRECTORIES
        "${OpenAL-Soft_INCLUDE_DIR}"
      IMPORTED_LOCATION
        "${OpenAL-Soft_LIBRARY}"
  )
endif ()

################################################################################
