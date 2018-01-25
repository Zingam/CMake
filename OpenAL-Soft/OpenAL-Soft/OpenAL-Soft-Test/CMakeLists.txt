################################################################################
# Project: OpenAL-Soft
################################################################################

cmake_minimum_required (VERSION 3.10)

message ("${ProjectName}: Configuring ${ProjectName}")

add_executable ("${ProjectName}" "Sources/main.cpp")
target_link_libraries("${ProjectName}"
  "OpenAL-Soft_Library"
)

add_custom_command (TARGET "${ProjectName}"
  POST_BUILD 
    COMMAND ${CMAKE_COMMAND} -E copy_if_different
      $<TARGET_FILE:OpenAL>
      $<TARGET_FILE_DIR:OpenAL-Soft-Test>
)

################################################################################
