! #ifndef OMP_TESTSUITE_H
! #define OMP_TESTSUITE_H

! #define LOOPCOUNT 10000

        integer check_omp_critical
        integer check_omp_atomic
        integer check_omp_barrier
        integer check_omp_flush
        integer check_omp_critical
        integer check_omp_atomic
        integer check_for_ordered
        integer check_for_reduction
        integer check_for_private
        integer check_for_firstprivate
        integer check_for_lastprivate
        integer check_has_openmp
        integer check_omp_get_num_threads
        integer check_omp_in_parallel
        integer check_omp_lock
        integer check_omp_testlock
        integer check_omp_nest_lock
        integer check_omp_nest_testlock
        integer check_omp_master_thread
        integer checkomp_get_num_threads
        integer check_for_private
        integer check_p_for_ordered
        integer check_p_for_reduction
        integer check_p_for_private
        integer check_p_for_firstprivate
        integer check_p_for_lastprivate
        integer check_p_section_reduction
        integer check_p_section_private
        integer check_p_section_firstprivate
        integer check_p_section_lastprivate
        integer check_for_schedule
        integer check_section_reduction
        integer check_section_private
        integer check_section_firstprivate
        integer check_section_lastprivate
        integer check_single
        integer check_single_private
        integer check_single_nowait
        integer check_single_copyprivate
        integer check_omp_threadprivate
        integer check_omp_copyin
        integer check_omp_copyprivate
        integer omp_check_time
        integer omp_check_ticks_time
        integer omp_check_num_threads


        integer crosscheck_omp_critical
        integer crosscheck_omp_atomic
        integer crosscheck_omp_barrier
        integer crosscheck_omp_flush
        integer crosscheck_omp_critical
        integer crosscheck_omp_atomic
        integer crosscheck_for_ordered
        integer crosscheck_for_reduction
        integer crosscheck_for_private
        integer crosscheck_for_firstprivate
        integer crosscheck_for_lastprivate
        integer crosscheck_has_openmp
        integer crosscheck_omp_get_num_threads
        integer crosscheck_omp_in_parallel
        integer crosscheck_omp_lock
        integer crosscheck_omp_testlock
        integer crosscheck_omp_nest_lock
        integer crosscheck_omp_nest_testlock
        integer crosscheck_omp_master_thread
        integer crosscheck_for_num_threads
        integer crosscheckomp_get_num_threads
        integer crosscheck_for_private
        integer crosscheck_p_for_ordered
        integer crosscheck_p_for_reduction
        integer crosscheck_p_for_private
        integer crosscheck_p_for_firstprivate
        integer crosscheck_p_for_lastprivate
        integer crosscheck_p_section_reduction
        integer crosscheck_p_section_private
        integer crosscheck_p_section_fprivate
        integer crosscheck_p_section_lprivate
        integer crosscheck_for_schedule
        integer crosscheck_section_reduction
        integer crosscheck_section_private
        integer crosscheck_section_firstprivate
        integer crosscheck_section_lastprivate
        integer crosscheck_single
        integer crosscheck_single_private
        integer crosscheck_single_nowait
        integer crosscheck_single_copyprivate
        integer crosscheck_omp_threadprivate
        integer crosscheck_omp_copyin
        integer crosscheck_single_copyprivate

        integer omp_crosscheck_time
        integer omp_crosscheck_ticks_time
        integer omp_crosscheck_num_threads

        integer LOOPCOUNT = 1000

! typedef         integer (*a_ptr_to_test_function)


! #endif
