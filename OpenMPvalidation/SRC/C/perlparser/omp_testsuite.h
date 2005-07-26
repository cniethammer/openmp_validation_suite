/* Global headerfile of the OpenMP Testsuite */

/* This file was created with the ompts_makeHeder.pl script using the following opions: */
/* No options were specified */


#ifndef OMP_TESTSUITE_H
#define OMP_TESTSUITE_H

#include <stdio.h>
#include <omp.h>

#define LOOPCOUNT 1000
#define REPETITIONS 20

int check_omp_single(FILE * logfile);  /* Test for omp single */
int crosscheck_omp_single(FILE * logfile);  /* Crosstest for omp single */
int check_has_openmp(FILE * logfile);  /* Test for _OPENMP */
int crosscheck_has_openmp(FILE * logfile);  /* Crosstest for _OPENMP */
int check_omp_atomic(FILE * logfile);  /* Test for omp atomic */
int crosscheck_omp_atomic(FILE * logfile);  /* Crosstest for omp atomic */
int check_omp_barrier(FILE * logfile);  /* Test for omp barrier */
int crosscheck_omp_barrier(FILE * logfile);  /* Crosstest for omp barrier */
int check_omp_critical(FILE * logfile);  /* Test for omp critical */
int crosscheck_omp_critical(FILE * logfile);  /* Crosstest for omp critical */
int check_omp_flush(FILE * logfile);  /* Test for omp flush */
int crosscheck_omp_flush(FILE * logfile);  /* Crosstest for omp flush */
int check_omp_for_firstprivate(FILE * logfile);  /* Test for omp for firstprivate */
int crosscheck_omp_for_firstprivate(FILE * logfile);  /* Crosstest for omp for firstprivate */
int check_omp_for_lastprivate(FILE * logfile);  /* Test for omp for lastprivate */
int crosscheck_omp_for_lastprivate(FILE * logfile);  /* Crosstest for omp for lastprivate */
int check_omp_for_ordered(FILE * logfile);  /* Test for omp for ordered */
int crosscheck_omp_for_ordered(FILE * logfile);  /* Crosstest for omp for ordered */
int check_omp_for_private(FILE * logfile);  /* Test for omp for private */
int crosscheck_omp_for_private(FILE * logfile);  /* Crosstest for omp for private */
int check_omp_for_reduction(FILE * logfile);  /* Test for omp for reduction */
int crosscheck_omp_for_reduction(FILE * logfile);  /* Crosstest for omp for reduction */
int check_omp_for_schedule_dynamic(FILE * logfile);  /* Test for omp for schedule(dynamic) */
int crosscheck_omp_for_schedule_dynamic(FILE * logfile);  /* Crosstest for omp for schedule(dynamic) */
int check_omp_for_schedule_guided(FILE * logfile);  /* Test for omp for schedule(guided) */
int crosscheck_omp_for_schedule_guided(FILE * logfile);  /* Crosstest for omp for schedule(guided) */
int check_omp_for_schedule_static(FILE * logfile);  /* Test for omp for schedule(static) */
int crosscheck_omp_for_schedule_static(FILE * logfile);  /* Crosstest for omp for schedule(static) */
int check_omp_get_num_threads(FILE * logfile);  /* Test for omp_get_num_threads */
int crosscheck_omp_get_num_threads(FILE * logfile);  /* Crosstest for omp_get_num_threads */
int check_omp_get_wtick(FILE * logfile);  /* Test for omp_get_wtick */
int crosscheck_omp_get_wtick(FILE * logfile);  /* Crosstest for omp_get_wtick */
int check_omp_get_wtime(FILE * logfile);  /* Test for omp_get_wtime */
int crosscheck_omp_get_wtime(FILE * logfile);  /* Crosstest for omp_get_wtime */
int check_omp_in_parallel(FILE * logfile);  /* Test for omp_in_parallel */
int crosscheck_omp_in_parallel(FILE * logfile);  /* Crosstest for omp_in_parallel */
int check_omp_lock(FILE * logfile);  /* Test for omp_lock */
int crosscheck_omp_lock(FILE * logfile);  /* Crosstest for omp_lock */
int check_omp_master(FILE * logfile);  /* Test for omp master */
int crosscheck_omp_master(FILE * logfile);  /* Crosstest for omp master */
int check_omp_nest_lock(FILE * logfile);  /* Test for omp_nest_lock */
int crosscheck_omp_nest_lock(FILE * logfile);  /* Crosstest for omp_nest_lock */
int check_omp_parallel_copyin(FILE * logfile);  /* Test for omp parallel copyin */
int crosscheck_omp_parallel_copyin(FILE * logfile);  /* Crosstest for omp parallel copyin */
int check_omp_parallel_for_firstprivate(FILE * logfile);  /* Test for omp parallel for firstprivate */
int crosscheck_omp_parallel_for_firstprivate(FILE * logfile);  /* Crosstest for omp parallel for firstprivate */
int check_omp_parallel_for_lastprivate(FILE * logfile);  /* Test for omp parallel for lastprivate */
int crosscheck_omp_parallel_for_lastprivate(FILE * logfile);  /* Crosstest for omp parallel for lastprivate */
int check_omp_parallel_for_ordered(FILE * logfile);  /* Test for omp parallel for ordered */
int crosscheck_omp_parallel_for_ordered(FILE * logfile);  /* Crosstest for omp parallel for ordered */
int check_omp_parallel_for_private(FILE * logfile);  /* Test for omp parallel for private */
int crosscheck_omp_parallel_for_private(FILE * logfile);  /* Crosstest for omp parallel for private */
int check_omp_parallel_for_reduction(FILE * logfile);  /* Test for omp parallel for reduction */
int crosscheck_omp_parallel_for_reduction(FILE * logfile);  /* Crosstest for omp parallel for reduction */
int check_omp_parallel_num_threads(FILE * logfile);  /* Test for omp parellel num_threads */
int crosscheck_omp_parallel_num_threads(FILE * logfile);  /* Crosstest for omp parellel num_threads */
int check_omp_parallel_sections_firstprivate(FILE * logfile);  /* Test for omp parallel sections firstprivate */
int crosscheck_omp_parallel_sections_firstprivate(FILE * logfile);  /* Crosstest for omp parallel sections firstprivate */
int check_omp_parallel_sections_lastprivate(FILE * logfile);  /* Test for omp parallel sections lastprivate */
int crosscheck_omp_parallel_sections_lastprivate(FILE * logfile);  /* Crosstest for omp parallel sections lastprivate */
int check_omp_parallel_sections_private(FILE * logfile);  /* Test for omp parallel sections private */
int crosscheck_omp_parallel_sections_private(FILE * logfile);  /* Crosstest for omp parallel sections private */
int check_omp_parallel_sections_reduction(FILE * logfile);  /* Test for omp parallel sections reduction */
int crosscheck_omp_parallel_sections_reduction(FILE * logfile);  /* Crosstest for omp parallel sections reduction */
int check_omp_section_firstprivate(FILE * logfile);  /* Test for omp firstprivate */
int crosscheck_omp_section_firstprivate(FILE * logfile);  /* Crosstest for omp firstprivate */
int check_omp_section_lastprivate(FILE * logfile);  /* Test for omp section lastprivate */
int crosscheck_omp_section_lastprivate(FILE * logfile);  /* Crosstest for omp section lastprivate */
int check_omp_section_private(FILE * logfile);  /* Test for omp section private */
int crosscheck_omp_section_private(FILE * logfile);  /* Crosstest for omp section private */
int check_omp_sections_reduction(FILE * logfile);  /* Test for omp sections reduction */
int crosscheck_omp_sections_reduction(FILE * logfile);  /* Crosstest for omp sections reduction */
int check_omp_single(FILE * logfile);  /* Test for omp single */
int crosscheck_omp_single(FILE * logfile);  /* Crosstest for omp single */
int check_omp_single_copyprivate(FILE * logfile);  /* Test for omp single copyprivate */
int crosscheck_omp_single_copyprivate(FILE * logfile);  /* Crosstest for omp single copyprivate */
int check_omp_single_nowait(FILE * logfile);  /* Test for omp single nowait */
int crosscheck_omp_single_nowait(FILE * logfile);  /* Crosstest for omp single nowait */
int check_omp_single_private(FILE * logfile);  /* Test for omp singel private */
int crosscheck_omp_single_private(FILE * logfile);  /* Crosstest for omp singel private */
int check_omp_test_lock(FILE * logfile);  /* Test for omp_test_lock */
int crosscheck_omp_test_lock(FILE * logfile);  /* Crosstest for omp_test_lock */
int check_omp_test_nest_lock(FILE * logfile);  /* Test for omp_test_nest_lock */
int crosscheck_omp_test_nest_lock(FILE * logfile);  /* Crosstest for omp_test_nest_lock */
int check_omp_threadprivate(FILE * logfile);  /* Test for omp threadprivate */
int crosscheck_omp_threadprivate(FILE * logfile);  /* Crosstest for omp threadprivate */
int check_omp_critical(FILE * logfile);  /* Test for omp critical */
int crosscheck_omp_critical(FILE * logfile);  /* Crosstest for omp critical */
int check_omp_master(FILE * logfile);  /* Test for omp master */
int crosscheck_omp_master(FILE * logfile);  /* Crosstest for omp master */
int check_omp_atomic(FILE * logfile);  /* Test for omp atomic */
int crosscheck_omp_atomic(FILE * logfile);  /* Crosstest for omp atomic */
int check_omp_barrier(FILE * logfile);  /* Test for omp barrier */
int crosscheck_omp_barrier(FILE * logfile);  /* Crosstest for omp barrier */
int check_omp_for_ordered(FILE * logfile);  /* Test for omp for ordered */
int crosscheck_omp_for_ordered(FILE * logfile);  /* Crosstest for omp for ordered */
int check_omp_flush(FILE * logfile);  /* Test for omp flush */
int crosscheck_omp_flush(FILE * logfile);  /* Crosstest for omp flush */
int check_parallel_for_ordered(FILE * logfile);  /* Test for omp parallel for ordered */
int crosscheck_parallel_for_ordered(FILE * logfile);  /* Crosstest for omp parallel for ordered */
int check_omp_for_firstprivate(FILE * logfile);  /* Test for omp for firstprivate */
int crosscheck_omp_for_firstprivate(FILE * logfile);  /* Crosstest for omp for firstprivate */
int check_omp_for_lastprivate(FILE * logfile);  /* Test for omp for lastprivate */
int crosscheck_omp_for_lastprivate(FILE * logfile);  /* Crosstest for omp for lastprivate */
int check_omp_for_private(FILE * logfile);  /* Test for omp for private */
int crosscheck_omp_for_private(FILE * logfile);  /* Crosstest for omp for private */
int check_omp_for_schedule_guided(FILE * logfile);  /* Test for omp for schedule(guided) */
int crosscheck_omp_for_schedule_guided(FILE * logfile);  /* Crosstest for omp for schedule(guided) */
int check_omp_atomic(FILE * logfile);  /* Test for omp atomic */
int crosscheck_omp_atomic(FILE * logfile);  /* Crosstest for omp atomic */
int check_has_openmp(FILE * logfile);  /* Test for _OPENMP */
int crosscheck_has_openmp(FILE * logfile);  /* Crosstest for _OPENMP */
int check_omp_critical(FILE * logfile);  /* Test for omp critical */
int crosscheck_omp_critical(FILE * logfile);  /* Crosstest for omp critical */
int check_omp_for_reduction(FILE * logfile);  /* Test for omp for reduction */
int crosscheck_omp_for_reduction(FILE * logfile);  /* Crosstest for omp for reduction */
int check_omp_for_firstprivate(FILE * logfile);  /* Test for omp for firstprivate */
int crosscheck_omp_for_firstprivate(FILE * logfile);  /* Crosstest for omp for firstprivate */
int check_omp_for_schedule_dynamic(FILE * logfile);  /* Test for omp for schedule(dynamic) */
int crosscheck_omp_for_schedule_dynamic(FILE * logfile);  /* Crosstest for omp for schedule(dynamic) */
int check_omp_for_lastprivate(FILE * logfile);  /* Test for omp for lastprivate */
int crosscheck_omp_for_lastprivate(FILE * logfile);  /* Crosstest for omp for lastprivate */
int check_omp_for_ordered(FILE * logfile);  /* Test for omp for ordered */
int crosscheck_omp_for_ordered(FILE * logfile);  /* Crosstest for omp for ordered */
int check_omp_for_private(FILE * logfile);  /* Test for omp for private */
int crosscheck_omp_for_private(FILE * logfile);  /* Crosstest for omp for private */
int check_omp_for_lastprivate(FILE * logfile);  /* Test for omp for lastprivate */
int crosscheck_omp_for_lastprivate(FILE * logfile);  /* Crosstest for omp for lastprivate */

#endif