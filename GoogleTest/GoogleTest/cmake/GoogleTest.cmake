option (option_EnableUnitTests "Enables unit tests" NO)

if (option_EnableUnitTests)
  message ("    ==> Unit Tests are enabled.")

  enable_testing ()

  # Download and unpack googletest at configure time
  configure_file (Tests/CMakeLists.txt.in googletest-download/CMakeLists.txt)
  execute_process (COMMAND ${CMAKE_COMMAND} -G "${CMAKE_GENERATOR}" .
    RESULT_VARIABLE result
    WORKING_DIRECTORY ${CMAKE_BINARY_DIR}/googletest-download
  )
  if (result)
    message(FATAL_ERROR "CMake step for googletest failed: ${result}")
  endif()

  execute_process(COMMAND ${CMAKE_COMMAND} --build .
    RESULT_VARIABLE result
    WORKING_DIRECTORY ${CMAKE_BINARY_DIR}/googletest-download
  )
  if (result)
    message(FATAL_ERROR "Build step for googletest failed: ${result}")
  endif()

  # Prevent overriding the parent project's compiler/linker
  # settings on Windows
  set (gtest_force_shared_crt ON CACHE BOOL "" FORCE)

  # Add googletest directly to our build. This defines
  # the gtest and gtest_main targets.
  add_subdirectory (${CMAKE_BINARY_DIR}/googletest-src
                    ${CMAKE_BINARY_DIR}/googletest-build
                    EXCLUDE_FROM_ALL
  )
else ()
  message ("    ==> Unit Tests are disabled.")
endif ()
