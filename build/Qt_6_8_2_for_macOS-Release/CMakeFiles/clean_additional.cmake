# Additional clean files
cmake_minimum_required(VERSION 3.16)

if("${CONFIG}" STREQUAL "" OR "${CONFIG}" STREQUAL "Release")
  file(REMOVE_RECURSE
  "CMakeFiles/appTheNinthLab_autogen.dir/AutogenUsed.txt"
  "CMakeFiles/appTheNinthLab_autogen.dir/ParseCache.txt"
  "appTheNinthLab_autogen"
  )
endif()
