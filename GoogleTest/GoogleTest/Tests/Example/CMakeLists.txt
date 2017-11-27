# Now simply link against gtest or gtest_main as needed.
set (Example_SourceFiles
  "Sources/Example.cpp"
)
add_executable (Example "${Example_SourceFiles}")
target_link_libraries (Example
  gtest_main
)

add_test (NAME Example COMMAND Example WORKING_DIRECTORY ${CMAKE_INSTALL_PREFIX})
get_property (prop TEST Example PROPERTY WORKING_DIRECTORY)
message (tests should be here " ${prop}")
