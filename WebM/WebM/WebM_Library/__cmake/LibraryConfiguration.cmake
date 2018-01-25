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
  # Library_ProjectSourceDirectory - the location of 
  # CMakeLists.txt.in
  set (Library_ProjectSourceDirectory 
    "__cmake"
  )
  # Library_BinaryDirectory - the location where the 
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
  
  # Add the library directly to the build. This defines the library targets.
  add_subdirectory (
    "${Library_BinaryDirectory}/${SubprojectName}/${SubprojectName}-source"
    "${Library_BinaryDirectory}/${SubprojectName}/${SubprojectName}-binary"
    EXCLUDE_FROM_ALL
  )

  # Add to a project folder for generators that support this feature
  set_target_properties (${SubprojectTargetNames}
    PROPERTIES FOLDER
      "ThirdParty/${SubprojectName}"
  )

  add_library ("${SubprojectName}_Library" INTERFACE)
  target_link_libraries ("${SubprojectName}_Library"
    INTERFACE
      ${SubprojectTargetNames}
  )
  target_include_directories ("${SubprojectName}_Library"
    INTERFACE
      "${Library_BinaryDirectory}/${SubprojectName}/${SubprojectName}-source"
  )
endif ()
