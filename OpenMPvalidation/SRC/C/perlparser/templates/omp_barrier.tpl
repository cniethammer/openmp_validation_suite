<ompts:test>
<ompts:testdescription>Test which checks the omp barrier directive. The test creates several threads and </ompts:testdescription>
<ompts:ompversion>2.0</ompts:ompversion>
<ompts:directive>omp barrier</ompts:directive>
<ompts:testcode>
#include <stdio.h>
#include <unistd.h>
#include <omp.h>
#include "omp_testsuite.h"
#include "omp_my_sleep.h"

int <ompts:testcode:functionname>omp_barrier</ompts:testcode:functionname>(FILE * logFile){
  int result1=0;
  int result2=0;
#pragma omp parallel
  {
    int rank;
    rank=omp_get_thread_num();
    if(rank==1){
      my_sleep(1.);
      result2=3;
    }
<ompts:check>#pragma omp barrier</ompts:check><ompts:crosscheck></ompts:crosscheck>
    if(rank==0){
      result1=result2;
    }
  }
  return (result1==3);
}
</ompts:testcode>
</ompts:test>