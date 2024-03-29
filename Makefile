CC = gcc
CFLAGS = -lpthread

BARRIER_FILES = barrier.h barrier.c

all: examples tests benchmarks
examples: parallel_sum sleepy_threads
tests: parallel_sum_test
benchmarks: thousand_threads

# Parallel sum example
PARALLEL_SUM_FILES = examples/parallel_sum.c
parallel_sum: parallel_sum_custom parallel_sum_posix

parallel_sum_custom: $(PARALLEL_SUM_FILES) $(BARRIER_FILES)
	$(CC) -o parallel_sum_custom $(CFLAGS) $(PARALLEL_SUM_FILES) $(BARRIER_FILES)

parallel_sum_posix: $(COMMON_FILES)
	$(CC) -o parallel_sum_posix -DPOSIX_BARRIERS $(CFLAGS) $(PARALLEL_SUM_FILES)


# Sleepy threads example
SLEEPY_THREADS_FILES = examples/sleepy_threads.c
sleepy_threads: sleepy_threads_custom sleepy_threads_posix

sleepy_threads_custom:
	$(CC) -o sleepy_threads_custom $(CFLAGS) $(SLEEPY_THREADS_FILES) $(BARRIER_FILES)

sleepy_threads_posix:
	$(CC) -o sleepy_threads_posix -DPOSIX_BARRIERS $(CFLAGS) $(SLEEPY_THREADS_FILES)


# Parallel sum test
PARALLEL_SUM_TEST_FILES = tests/parallel_sum_test.c
parallel_sum_test: parallel_sum_test_barrier parallel_sum_test_no_barrier

parallel_sum_test_barrier: $(PARALLEL_SUM_TEST_FILES) $(BARRIER_FILES)
	$(CC) -o parallel_sum_test_barrier $(CFLAGS) $(PARALLEL_SUM_TEST_FILES) $(BARRIER_FILES)

parallel_sum_test_no_barrier: $(PARALLEL_SUM_TEST_FILES)
	$(CC) -o parallel_sum_test_no_barrier -DNO_BARRIER $(CFLAGS) $(PARALLEL_SUM_TEST_FILES)

# Thousand threads waiting benchmark
THOUSAND_THREADS_FILES = benchmarks/thousand_threads_waiting.c
thousand_threads: thousand_threads_custom thousand_threads_posix

thousand_threads_custom:
	$(CC) -o thousand_threads_custom $(CFLAGS) $(THOUSAND_THREADS_FILES) $(BARRIER_FILES)

thousand_threads_posix:
	$(CC) -o thousand_threads_posix -DPOSIX_BARRIERS $(CFLAGS) $(THOUSAND_THREADS_FILES)


clean:
	-rm \
		parallel_sum_posix parallel_sum_custom \
		sleepy_threads_custom sleepy_threads_posix \
		parallel_sum_test_barrier parallel_sum_test_no_barrier \
		thousand_threads_custom thousand_threads_posix
