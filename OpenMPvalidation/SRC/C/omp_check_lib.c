#include <stdio.h>
#include "omp.h"
#include "omp_testsuite.h"


int check_has_openmp(FILE * logFile){
  int rvalue=0;
#ifdef _OPENMP
  rvalue=1;
#endif
  return rvalue;
}

int crosscheck_has_openmp(FILE * logFile){
  int rvalue=0;
#if 0
  rvalue=1;
#endif
  return rvalue;
}

int check_omp_get_num_threads(FILE * logFile){
  /* checks that omp_get_num_threads is equal to the number of
     threads */
  int nthreads=0;
  int nthreads_lib=-1;
#pragma omp parallel 
  {
    #pragma omp critical
    {
      nthreads++;
    }
    #pragma omp single
    { 
      nthreads_lib=omp_get_num_threads();
    }
  } /* end of parallel */
  return nthreads==nthreads_lib;
}

int crosscheck_omp_get_num_threads(FILE * logFile){
  /* checks that omp_get_num_threads is equal to the number of
     threads */
  int nthreads=0;
  int nthreads_lib=-1;
#pragma omp parallel 
  {
    #pragma omp critical
    {
      nthreads++;
    }
    #pragma omp single
    { 
      /*nthreads_lib=omp_get_num_threads();*/
    }
  } /* end of parallel */
  return nthreads==nthreads_lib;
}

int check_omp_in_parallel(FILE * logFile){
  /* checks that false is returned when called from serial region
     and true is returned when called within parallel region */
  int serial=1;
  int isparallel=0;
  serial=omp_in_parallel();
#pragma omp parallel
  {
#pragma omp single
    {
      isparallel=omp_in_parallel();
    }
  }
  return ( !(serial) && isparallel );
}

int crosscheck_omp_in_parallel(FILE * logFile){
  /* checks that false is returned when called from serial region
     and true is returned when called within parallel region */
  int serial=1;
  int isparallel=0;
  /*serial=omp_in_parallel();*/
#pragma omp parallel
  {
#pragma omp single
    {
      /*isparallel=omp_in_parallel();*/
    }
  }
  return ( !(serial) && isparallel );
}
