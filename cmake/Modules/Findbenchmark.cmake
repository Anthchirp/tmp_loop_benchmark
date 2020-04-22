# Try to find the Google Benchmark library and headers.
#  benchmark_FOUND        - system has benchmark lib
#  benchmark_INCLUDE_DIRS - the benchmark include directory
#  benchmark_LIBRARIES    - libraries needed to use benchmark

find_path(benchmark_INCLUDE_DIR
  NAMES benchmark/benchmark.h
  PATHS ${BENCHMARK_BASE}/include
  DOC "The directory where benchmark includes reside"
)

find_library(benchmark_LIBRARY
  NAMES benchmark
  PATHS ${BENCHMARK_BASE}/build/src
  DOC "The benchmark library"
)

set(benchmark_INCLUDE_DIRS ${benchmark_INCLUDE_DIR})
set(benchmark_LIBRARIES    ${benchmark_LIBRARY})

include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(benchmark
  FOUND_VAR benchmark_FOUND
  REQUIRED_VARS benchmark_INCLUDE_DIR benchmark_LIBRARY
)

add_library(benchmark::benchmark IMPORTED INTERFACE)

include_directories(${benchmark_INCLUDE_DIRS})
target_link_libraries(benchmark::benchmark INTERFACE ${benchmark_LIBRARIES})

mark_as_advanced(benchmark_FOUND)

