#include <benchmark/benchmark.h>

#include <scitbx/array_family/accessors/c_grid.h>
#include <scitbx/array_family/tiny_types.h>
#include <scitbx/array_family/versa.h>

using namespace scitbx;

static void BM_loop_inside(benchmark::State& state) {
  af::versa<bool, af::c_grid<3> > base(af::c_grid<3>(af::tiny<int, 3>(14, 14, 5)));
  af::versa<bool, af::c_grid<3> > m(base.accessor());

  for (auto _ : state) {
    for (std::size_t j = 0; j < m.size(); ++j) {
      benchmark::DoNotOptimize(m[j] = base[j]);
    }
  }
}
BENCHMARK(BM_loop_inside);

static void BM_loop_outside(benchmark::State& state) {
  af::versa<bool, af::c_grid<3> > base(af::c_grid<3>(af::tiny<int, 3>(14, 14, 5)));
  af::versa<bool, af::c_grid<3> > m(base.accessor());

  for (auto _ : state) {
    const auto size = m.size();
    for (std::size_t j = 0; j < size; ++j) {
      benchmark::DoNotOptimize(m[j] = base[j]);
    }
  }
}
BENCHMARK(BM_loop_outside);

BENCHMARK_MAIN();
