message ("${ProjectName}: Configuring ${ProjectName}")
add_executable ("${ProjectName}" "Sources/main.cpp")
target_link_libraries("${ProjectName}"
  "Opus_Library"
)

if (UseDynamicLibrary)
  add_custom_command (TARGET "${ProjectName}"
    POST_BUILD 
      COMMAND ${CMAKE_COMMAND} -E copy_if_different
        $<TARGET_FILE:vpx>
        $<TARGET_FILE_DIR:${ProjectName}>
  )
endif ()
