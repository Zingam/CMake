################################################################################
# Module: FindSteamworks
################################################################################
# Defines:
#   * Imported targets:
#       REngine::Steamworks
#   * Variables:
#       Steamworks_FOUND
#       Steamworks_INCLUDE_DIR
#       Steamworks_LIBRARIES
#       Steamworks_SHARED_LIBRARIES
################################################################################

# Search path suffix corresponding to the platform
if ("${CMAKE_SYSTEM_NAME}" STREQUAL "Windows")
  set (LibrarySearchPathSuffix "win")
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

set (HeaderFile "steam/steam_api.h")
find_path (Steam_INCLUDE_DIR
  NAMES
    ${HeaderFile}
  PATHS
    "$ENV{__EXTERNAL_LIBS}/Steamworks"
    "$ENV{STEAM_SDK}"
  PATH_SUFFIXES
    "/public"
    "/steamworks_sdk_142/sdk/public"
    "/steamworks_sdk_135/sdk/public"
)
if (NOT Steam_INCLUDE_DIR)
  message (FATAL_ERROR "Unable to find header file: \"${HeaderFile}\"")
else ()
  list (APPEND Steamworks_INCLUDE_DIR "${Steam_INCLUDE_DIR}")
endif ()

################################################################################
# Library files
################################################################################

set (LibraryFile "steam_api")
if ("${CMAKE_SYSTEM_NAME}" STREQUAL "Windows"
  AND "${CMAKE_SIZEOF_VOID_P}" STREQUAL "8"
)
  set (LibraryFile "${LibraryFile}64")
endif ()
find_library (steam_api_LIBRARY
  NAMES
    ${LibraryFile}
  PATHS
    "$ENV{__EXTERNAL_LIBS}/Steamworks"
    "$ENV{STEAM_SDK}"
  PATH_SUFFIXES
    "/redistributable_bin"
    "/redistributable_bin/${LibrarySearchPathSuffix}"
    "/steamworks_sdk_142/sdk/redistributable_bin/${LibrarySearchPathSuffix}"
    "/steamworks_sdk_135/sdk/redistributable_bin/${LibrarySearchPathSuffix}"
)
# Hide internal implementation details from user
set_property (CACHE steam_api_LIBRARY PROPERTY TYPE INTERNAL)
if (NOT steam_api_LIBRARY)
  message (FATAL_ERROR "Unable to find library file: \"${LibraryFile}\"")
else ()
  list (APPEND Steamworks_LIBRARIES "${steam_api_LIBRARY}")
endif ()

if ("${CMAKE_SYSTEM_NAME}" STREQUAL "Windows")
  set (LibraryFile "${LibraryFile}.dll")
  find_file (steam_api_SHARED_LIBRARY
    NAMES
      ${LibraryFile}
    PATHS
      "$ENV{__EXTERNAL_LIBS}/Steamworks"
      "$ENV{STEAM_SDK}"
    PATH_SUFFIXES
      "/redistributable_bin"
      "/redistributable_bin/${LibrarySearchPathSuffix}"
  )
  # Hide internal implementation details from user
  set_property (CACHE steam_api_SHARED_LIBRARY PROPERTY TYPE INTERNAL)
  if (NOT steam_api_SHARED_LIBRARY)
    message (FATAL_ERROR "Unable to find library file: \"${LibraryFile}\"")
  else ()
    list (APPEND Steamworks_SHARED_LIBRARIES "${steam_api_SHARED_LIBRARY}")
  endif ()
endif ()

set (LibraryFile "sdkencryptedappticket")
if ("${CMAKE_SYSTEM_NAME}" STREQUAL "Windows"
  AND "${CMAKE_SIZEOF_VOID_P}" STREQUAL "8"
)
  set (LibraryFile "${LibraryFile}64")
endif ()
find_library (sdkencryptedappticket_LIBRARY
  NAMES
    ${LibraryFile}
  PATHS
    "$ENV{__EXTERNAL_LIBS}/Steamworks"
    "$ENV{STEAM_SDK}"
  PATH_SUFFIXES
    "/public/steam/lib/${LibrarySearchPathSuffix}"
    "/steamworks_sdk_142/sdk/public/steam/lib/${LibrarySearchPathSuffix}"
    "/steamworks_sdk_135/sdk/public/steam/lib/${LibrarySearchPathSuffix}"
)
# Hide internal implementation details from user
set_property (CACHE sdkencryptedappticket_LIBRARY PROPERTY TYPE INTERNAL)
if (NOT sdkencryptedappticket_LIBRARY)
  message (FATAL_ERROR "Unable to find library file: \"${LibraryFile}\"")
else ()
  list (APPEND Steamworks_LIBRARIES "${sdkencryptedappticket_LIBRARY}")
endif ()

if ("${CMAKE_SYSTEM_NAME}" STREQUAL "Windows")
  set (LibraryFile "${LibraryFile}.dll")
  find_file (sdkencryptedappticket_SHARED_LIBRARY
    NAMES
      ${LibraryFile}
    PATHS
      "$ENV{__EXTERNAL_LIBS}/Steamworks"
      "$ENV{STEAM_SDK}"
    PATH_SUFFIXES
      "/public/steam/lib/${LibrarySearchPathSuffix}"
      "/steamworks_sdk_142/sdk/public/steam/lib/${LibrarySearchPathSuffix}"
      "/steamworks_sdk_135/sdk/public/steam/lib/${LibrarySearchPathSuffix}"
  )
  # Hide internal implementation details from user
  set_property (CACHE sdkencryptedappticket_SHARED_LIBRARY PROPERTY TYPE INTERNAL)
  if (NOT sdkencryptedappticket_SHARED_LIBRARY)
    message (FATAL_ERROR "Unable to find library file: \"${LibraryFile}\"")
  else ()
    list (APPEND Steamworks_SHARED_LIBRARIES "${sdkencryptedappticket_SHARED_LIBRARY}")
  endif ()
endif ()

################################################################################
# find_package arguments
################################################################################

include (FindPackageHandleStandardArgs)

set (PackageVariables
  Steamworks_INCLUDE_DIR
  Steamworks_LIBRARIES
)
if (SDL2_SHARED_LIBRARY)
  set (PackageVariables ${PackageVariables} Steamworks_SHARED_LIBRARIES)
endif ()

find_package_handle_standard_args (Steamworks
  DEFAULT_MSG
    ${PackageVariables}
)
mark_as_advanced (${PackageVariables})

################################################################################
# Imported target
################################################################################

if (Steamworks_FOUND AND NOT TARGET REngine::Steamworks)
  add_library (REngine::Steamworks UNKNOWN IMPORTED)
  set_target_properties (REngine::Steamworks
    PROPERTIES
      INTERFACE_INCLUDE_DIRECTORIES
        "${Steamworks_INCLUDE_DIR}"
      IMPORTED_LOCATION
        "${steam_api_LIBRARY}"
      INTERFACE_LINK_LIBRARIES
        "${Steamworks_LIBRARIES}"
  )
endif ()

################################################################################
