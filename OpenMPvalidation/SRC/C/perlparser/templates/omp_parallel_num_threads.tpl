<ompts:test>
<ompts:testdescription>Test which checks the omp_parallel_num_threads directive by counting the threads in a parallel region which was started with an explicitly stated number of threads.</ompts:testdescription>
<ompts:ompversion>2.0</ompts:ompversion>
<ompts:directive>omp parellel num_threads</ompts:directive>
<ompts:dependences>omp master,omp parallel reduction,omp atomic</ompts:dependences>
<ompts:testcode>
#include <stdio.h>
#include <omp.h>
#include "omp_testsuite.h"

int <ompts:testcode:functionname>omp_parallel_num_threads</ompts:testcode:functionname>(FILE * logFile){
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
   
#pragma omp parallel reduction(+:failed) <ompts:check>num_threads(threads)</ompts:check><ompts:crosscheck></ompts:crosscheck>
  {
    failed=failed+!(threads==omp_get_num_threads());
#pragma omp atomic
    nthreads+=1;
  }
  failed=failed+!(nthreads==threads);
 }
 return !failed;
}
</ompts:testcode>
</ompts:test>
