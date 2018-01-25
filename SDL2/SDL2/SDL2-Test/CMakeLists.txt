################################################################################
# Project: SDL2
################################################################################

cmake_minimum_required (VERSION 3.10)

################################################################################

message ("${ProjectName}: Configuring ${ProjectName}")

################################################################################

add_executable ("${ProjectName}" "Sources/main.cpp")
target_link_libraries("${ProjectName}"
  "SDL2_Library"
)

add_custom_command (TARGET "SDL-Test"
  POST_BUILD 
    COMMAND ${CMAKE_COMMAND} -E copy_if_different
      $<TARGET_FILE:SDL2>
      $<TARGET_FILE_DIR:${ProjectName}>
)

################################################################################
