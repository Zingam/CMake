cmake_minimum_required(VERSION 2.8.2)

project (GoogleTest)

set (CMAKE_MODULE_PATH ${CMAKE_MODULE_PATH} "${CMAKE_SOURCE_DIR}/cmake/")

include (GoogleTest)

add_subdirectory (Tests)
