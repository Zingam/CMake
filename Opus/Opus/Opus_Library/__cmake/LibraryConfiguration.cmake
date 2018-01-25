################################################################################
include_guard() # Prevent this file from being included more than once
################################################################################

################################################################################
# This is a method to download, configure and build a library at configuration
# time
################################################################################

option (option_EnableLibrary_${SubprojectName} 
 "Enable library ${SubprojectName}" YES
)

if (option_EnableLibrary_${SubprojectName})
  # Set project directory variables
  # Library_${SubprojectName}_ProjectSourceDirectory - the location of 
  # CMakeLists.txt.in
  set (Library_ProjectSourceDirectory 
    "__cmake"
  )
  # Library_${SubprojectName}_BinaryDirectory - the location where the 
  # downloaded and compile files will be located
  set (Library_BinaryDirectory 
    "${CMAKE_BINARY_DIR}/ThirdParty/${SubprojectName}"
  )

  # Copy CMakeLists.txt.in defining the library target to the target directory
  configure_file (
    "${Library_ProjectSourceDirectory}/CMakeLists.txt.in"
    "${Library_BinaryDirectory}/CMakeLists.txt"
  )

  # Execute CMake to download the library and to generate the respective build
  # system in the target directory
  message ("===> Downloading ${SubprojectName} in ${Library_BinaryDirectory}")
  execute_process (
    COMMAND ${CMAKE_COMMAND} -G "${CMAKE_GENERATOR}" .
    RESULT_VARIABLE result
    WORKING_DIRECTORY "${Library_BinaryDirectory}"
  )
  if (result)
    message (FATAL_ERROR 
      "CMake configuration step for library ${SubprojectName} failed: ${result}"
    )
  endif()

  # Build the library in the target directory
  message ("===> Building ${SubprojectName} in ${Library_BinaryDirectory}")
  execute_process (
    COMMAND ${CMAKE_COMMAND} --build .
    RESULT_VARIABLE result
    WORKING_DIRECTORY "${Library_BinaryDirectory}"
  )
  if (result)
    message (FATAL_ERROR 
      "Build step for library ${SubprojectName} failed: ${result}"
    )
  endif()

  # Create the interface library
  add_library ("${SubprojectName}_Library" INTERFACE)

  if ("${CMAKE_SIZEOF_VOID_P}" STREQUAL "8")
    set (LibrarySearchPathSuffix "lib/x64")
  elseif ("${CMAKE_SIZEOF_VOID_P}" STREQUAL "4")
    set (LibrarySearchPathSuffix "lib/x86")
  else ()
    message (FATAL_ERROR "Unsupported architecture: ${CMAKE_SIZEOF_VOID_P} bit")
  endif ()
  
  if (DynamicLibraryName)
    find_library (DynamicLibraryFilename "${DynamicLibraryName}"
      PATHS
        "${Library_BinaryDirectory}/${SubprojectName}/${SubprojectName}-source"
      PATH_SUFFIXES
        "${LibrarySearchPathSuffix}"
    )
    message ("find_library result: DynamicLibraryFilename = ${DynamicLibraryFilename}")

    if (DynamicLibraryFilename)
      target_link_libraries ("${SubprojectName}_Library"
        INTERFACE
          "${DynamicLibraryFilename}"
      )
    else ()
      message (FATAL_ERROR 
        "${DynamicLibraryName} was not found: DynamicLibraryFilename = ${DynamicLibraryFilename}"
      )
    endif ()
  endif ()

  if (StaticLibraryName)
    find_library (StaticLibraryFilename "${StaticLibraryName}"
      PATHS
        "${Library_BinaryDirectory}/${SubprojectName}/${SubprojectName}-source"
      PATH_SUFFIXES
        "${LibrarySearchPathSuffix}"
    )
    message ("find_library (${StaticLibraryName}) result: StaticLibraryFilename = ${StaticLibraryFilename}")

    if (StaticLibraryFilename)
      target_link_libraries ("${SubprojectName}_Library"
        INTERFACE
          "${StaticLibraryFilename}"
      )
    else ()
      message (FATAL_ERROR 
        "${StaticLibraryName} was not found: StaticLibraryFilename = ${StaticLibraryFilename}"
      )
    endif ()
  endif ()

  if (HeaderName)
    find_path (HeaderFilePath "${HeaderName}"
      PATHS
        "${Library_BinaryDirectory}/${SubprojectName}/${SubprojectName}-source"
      PATH_SUFFIXES
        "include"
    )
     message ("find_path result: HeaderFilePath = ${HeaderFilePath}")

    if (HeaderFilePath)
      target_include_directories ("${SubprojectName}_Library"
        INTERFACE
          "${HeaderFilePath}"
      )
    else ()
      message (FATAL_ERROR 
        "${HeaderName} was not found: HeaderFilePath = ${HeaderFilePath}"
      )
    endif ()
  endif ()
endif ()
