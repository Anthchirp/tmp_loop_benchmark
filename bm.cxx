#include <benchmark/benchmark.h>

#include <scitbx/array_family/tiny_types.h>
// #include "dials/algorithms/image/threshold/local.h"

static void BM_loop_inside(benchmark::State& state) {
  for (auto _ : state) {
  }
}
BENCHMARK(BM_loop_inside);

static void BM_loop_outside(benchmark::State& state) {
  af::versa<bool, af::c_grid<3> > m(mask2.accessor());
  DIALS_ASSERT(mask1.size() == mask2.size());
  for (std::size_t j = 0; j < m.size(); ++j) {
    m[j] = mask1[j] && mask2[j];
  }
  for (auto _ : state) {
  }
}
BENCHMARK(BM_loop_outside);

BENCHMARK_MAIN();
