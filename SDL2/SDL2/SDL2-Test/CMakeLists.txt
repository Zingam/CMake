message ("SDL-Test: Configuring SDL-Test")
add_executable ("SDL-Test" "Sources/main.cpp")
target_link_libraries("SDL-Test"
  "SDL2_Library"
)

add_custom_command (TARGET "SDL-Test"
  POST_BUILD 
    COMMAND ${CMAKE_COMMAND} -E copy_if_different
      $<TARGET_FILE:SDL2>
      $<TARGET_FILE_DIR:SDL-Test>
)
