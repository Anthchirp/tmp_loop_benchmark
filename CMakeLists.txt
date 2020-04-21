cmake_minimum_required(VERSION 3.8 FATAL_ERROR)

cmake_policy(SET CMP0074 OLD) # XXX_ROOT

project(looptests)
# Boost imported target and cmake_parse_arguments were added in 3.5
# 3.8 added interface targets to OpenGL

# option(USE_OPENMP yes)
# option(USE_TBB no)

# Add the included modules
set(CMAKE_MODULE_PATH ${CMAKE_MODULE_PATH} "${CMAKE_SOURCE_DIR}/cmake/Modules/")

set(CMAKE_CXX_STANDARD 11)

find_package(Boost REQUIRED)
find_package(Dials REQUIRED)
find_package(benchmark REQUIRED)
# Not currently 100% on how needed this is for flex
set(EIGEN_ROOT ${DIALS_BUILD}/../modules/eigen)
find_package(Eigen3 REQUIRED)

add_executable(bm bm.cxx)
target_link_libraries(bm PUBLIC Dials::Dials benchmark::benchmark)
