#ifndef OMP_TESTSUITE_H
#define OMP_TESTSUITE_H

#define LOOPCOUNT 10000

int check_omp_critical();
int check_omp_atomic();
int check_omp_barrier();
int check_omp_flush();
int check_omp_critical();
int check_omp_atomic();
int check_for_ordered();
int check_for_reduction();
int check_for_private();
int check_for_firstprivate();
int check_for_lastprivate();
int check_has_openmp();
int check_omp_get_num_threads();
int check_omp_in_parallel();
int check_omp_lock();
int check_omp_testlock();
int check_omp_nest_lock();
int check_omp_nest_testlock();
int check_omp_master_thread();
int checkomp_get_num_threads();
int check_for_private();
int check_parallel_for_ordered();
int check_parallel_for_reduction();
int check_parallel_for_private();
int check_parallel_for_firstprivate();
int check_parallel_for_lastprivate();
int check_parallel_section_reduction();
int check_parallel_section_private();
int check_parallel_section_firstprivate();
int check_parallel_section_lastprivate();
int check_for_schedule();
int check_section_reduction();
int check_section_private();
int check_section_firstprivate();
int check_section_lastprivate();
int check_single();
int check_single_private();
int check_single_nowait();
int check_single_copyprivate();
int check_omp_threadprivate();
int check_omp_copyin();
int check_omp_copyprivate();
int omp_check_time();
int omp_check_ticks_time();
int omp_check_num_threads();


int crosscheck_omp_critical();
int crosscheck_omp_atomic();
int crosscheck_omp_barrier();
int crosscheck_omp_flush();
int crosscheck_omp_critical();
int crosscheck_omp_atomic();
int crosscheck_for_ordered();
int crosscheck_for_reduction();
int crosscheck_for_private();
int crosscheck_for_firstprivate();
int crosscheck_for_lastprivate();
int crosscheck_has_openmp();
int crosscheck_omp_get_num_threads();
int crosscheck_omp_in_parallel();
int crosscheck_omp_lock();
int crosscheck_omp_testlock();
int crosscheck_omp_nest_lock();
int crosscheck_omp_nest_testlock();
int crosscheck_omp_master_thread();
int crosscheck_for_num_threads();
int crosscheckomp_get_num_threads();
int crosscheck_for_private();
int crosscheck_parallel_for_ordered();
int crosscheck_parallel_for_reduction();
int crosscheck_parallel_for_private();
int crosscheck_parallel_for_firstprivate();
int crosscheck_parallel_for_lastprivate();
int crosscheck_parallel_section_reduction();
int crosscheck_parallel_section_private();
int crosscheck_parallel_section_firstprivate();
int crosscheck_parallel_section_lastprivate();
int crosscheck_for_schedule();
int crosscheck_section_reduction();
int crosscheck_section_private();
int crosscheck_section_firstprivate();
int crosscheck_section_lastprivate();
int crosscheck_single();
int crosscheck_single_private();
int crosscheck_single_nowait();
int crosscheck_single_copyprivate();
int crosscheck_omp_threadprivate();
int crosscheck_omp_copyin();
int crosscheck_single_copyprivate();

int omp_crosscheck_time();
int omp_crosscheck_ticks_time();
int omp_crosscheck_num_threads();


typedef int (*a_ptr_to_test_function)();



#endif
