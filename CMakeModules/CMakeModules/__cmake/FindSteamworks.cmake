################################################################################
# Module: FindSteamworks
################################################################################
# Defines:
#   * Imported targets:
#       REngine::Steamworks
#   * Variables:
#       Steamworks_FOUND
#       Steamworks_LIBRARY
#       Steamworks_LIBRARIES
#       Steamworks_INCLUDE_DIR
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

find_path (Steam_INCLUDE_DIR
  NAMES
    "steam/steam_api.h"
  PATHS
    "$ENV{IVENT_SOTS_EXTERNALIBS}/Steamworks"
    "$ENV{STEAM_SDK}"
  PATH_SUFFIXES
    "/public"
)
if (Steam_INCLUDE_DIR)
  list (APPEND Steamworks_INCLUDE_DIR "${Steam_INCLUDE_DIR}")
endif ()

find_library (sdkencryptedappticket_LIBRARY
  NAMES
    "sdkencryptedappticket"
    "sdkencryptedappticket64"
  PATHS
    "${IVENT_SOTS_EXTERNALIBS}/Steamworks"
    "$ENV{STEAM_SDK}"
  PATH_SUFFIXES
    "/public/steam/lib/${LibrarySearchPathSuffix}"
)
# Hide internal implementation details from user
set_property (CACHE sdkencryptedappticket_LIBRARY PROPERTY TYPE INTERNAL)
if (sdkencryptedappticket_LIBRARY)
  list (APPEND Steamworks_LIBRARIES "${sdkencryptedappticket_LIBRARY}")
endif ()

find_library (steam_api_LIBRARY
  NAMES
    "steam_api"
    "steam_api64"
  PATHS
    "${IVENT_SOTS_EXTERNALIBS}/Steamworks"
    "$ENV{STEAM_SDK}"
  PATH_SUFFIXES
    "/redistributable_bin/${LibrarySearchPathSuffix}"
)
# Hide internal implementation details from user
set_property (CACHE steam_api_LIBRARY PROPERTY TYPE INTERNAL)
if (steam_api_LIBRARY)
  list (APPEND Steamworks_LIBRARIES "${steam_api_LIBRARY}")
endif ()

include (FindPackageHandleStandardArgs)
find_package_handle_standard_args (Steamworks
  DEFAULT_MSG
    Steamworks_LIBRARIES
    Steamworks_INCLUDE_DIR
)
mark_as_advanced (
    Steamworks_LIBRARY
    Steamworks_LIBRARIES
    Steamworks_INCLUDE_DIR
)

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
