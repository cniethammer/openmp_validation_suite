#include <stdio.h>
#include <omp.h>
#include "omp_testsuite.h"

int omp_check_num_threads(FILE * logFile){
  int failed=0;
  int max_threads=0;
  int threads;
  int nthreads;
  /* first we check how many threads are available*/
#pragma omp parallel
 {
#pragma omp master
   max_threads=omp_get_num_threads();
 }
 
 /* we increase the number of threads from one to maximum:*/
 for(threads=1; threads<=max_threads;threads++){
   nthreads=0;
   
#pragma omp parallel num_threads(threads),reduction(+:failed)
  {
    failed=failed+!(threads==omp_get_num_threads());
#pragma omp atomic
    nthreads+=1;
  }
  failed=failed+!(nthreads==threads);
 }
 return !failed;
}

int omp_crosscheck_num_threads(FILE * logFile){
  int failed=0;
  int max_threads=0;
  int threads;
  int nthreads;
  /* first we check how many threads are available*/
#pragma omp parallel
 {
#pragma omp master
   max_threads=omp_get_num_threads();
 }
 
 /* we increase the number of threads from one to maximum:*/
 for(threads=1; threads<=max_threads;threads++){
   nthreads=0;
   
#pragma omp parallel reduction(+:failed)
  {
    failed=failed+!(threads==omp_get_num_threads());
#pragma omp atomic
    nthreads+=1;
  }
  failed=failed+!(nthreads==threads);
 }
 return !failed;
}


