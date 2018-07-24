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
#       OpenAL-Soft_SHARED_LIBRARY
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
    "$ENV{__EXTERNAL_LIBS}/OpenAL-Soft"
  PATH_SUFFIXES
    "/include"
)
if (NOT OpenAL-Soft_INCLUDE_DIR)
  message (FATAL_ERROR "Unable to find header file: \"${HeaderFile}\"")
endif ()

################################################################################
# Library files
################################################################################

macro (SetLibraryName)
  set (oneValueArgs WINDOWS LINUX MACOS)
  cmake_parse_arguments (SetLibraryName 
    "${options}" 
    "${oneValueArgs}"
    "${multiValueArgs}" ${ARGN}
  )

  if ("${CMAKE_SYSTEM_NAME}" STREQUAL "Windows")
    if (SetLibraryName_WINDOWS)
      set (LibraryName "${SetLibraryName_WINDOWS}")
    else ()
      message (FATAL_ERROR "SetLibraryName: Option WINDOWS is not set")
    endif ()
  elseif ("${CMAKE_SYSTEM_NAME}" STREQUAL "Linux")
    if (SetLibraryName_LINUX)
      set (LibraryName "${SetLibraryName_LINUX}")
    else ()
      message (FATAL_ERROR "SetLibraryName: Option LINUX is not set")
    endif ()
  elseif ("${CMAKE_SYSTEM_NAME}" STREQUAL "Darwin")
    if (SetLibraryName_MACOS)
      set (LibraryName "${SetLibraryName_MACOS}")
    else ()
      message (FATAL_ERROR "SetLibraryName: Option MACOS is not set")
    endif ()
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
  endif ()
endmacro ()

SetLibraryName(WINDOWS "OpenAL32" LINUX "openal")
set (LibraryFile ${LibraryName})
find_library (OpenAL-Soft_LIBRARY
  NAMES
    ${LibraryFile}
  PATHS
    "$ENV{__EXTERNAL_LIBS}/OpenAL-Soft"
  PATH_SUFFIXES
    "/libs/${LibrarySearchPathSuffix}"
)
if (NOT OpenAL-Soft_LIBRARY)
  message (FATAL_ERROR "Unable to find library file: \"${LibraryFile}\"")
endif ()

if ("${CMAKE_SYSTEM_NAME}" STREQUAL "Windows")
  set (LibraryFile "soft_oal.dll")
  find_file (OpenAL-Soft_SHARED_LIBRARY
    NAMES
      ${LibraryFile}
    PATHS
      "$ENV{__EXTERNAL_LIBS}/OpenAL-Soft"
    PATH_SUFFIXES
      "/bin/${LibrarySearchPathSuffix}"
  )
  # Hide internal implementation details from user
  set_property (CACHE OpenAL-Soft_SHARED_LIBRARY PROPERTY TYPE INTERNAL)
  if (NOT OpenAL-Soft_SHARED_LIBRARY)
    message (FATAL_ERROR "Unable to find library file: \"${LibraryFile}\"")
  endif ()
endif ()

################################################################################
# find_package arguments
################################################################################

include (FindPackageHandleStandardArgs)

set (PackageVariables
  OpenAL-Soft_INCLUDE_DIR
  OpenAL-Soft_LIBRARY
)
if (OpenAL-Soft_SHARED_LIBRARY)
  set (PackageVariables ${PackageVariables} OpenAL-Soft_SHARED_LIBRARY)
endif ()

find_package_handle_standard_args (OpenAL-Soft
  DEFAULT_MSG
    ${PackageVariables}
)
mark_as_advanced (${PackageVariables})

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
