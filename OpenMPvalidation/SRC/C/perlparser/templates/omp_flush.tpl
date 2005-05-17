<ompts:test>
<ompts:testdescription>Test which checks the omp flush directive.</ompts:testdescription>
<ompts:ompversion>2.0</ompts:ompversion>
<ompts:directive>omp flush</ompts:directive>
<ompts:dependences>omp barrier</ompts:dependences>
<ompts:testcode>
#include <stdio.h>
#include <unistd.h>
#include <omp.h>
#include "omp_testsuite.h"
#include "omp_my_sleep.h"

int <ompts:testcode:functionname>omp_flush</ompts:testcode:functionname>(FILE * logFile){
<ompts:orphan:vars>
  int result1=0;
  int result2=0;
  int dummy;
</ompts:orphan:vars>
#pragma omp parallel
  {
    int rank;
    rank=omp_get_thread_num();
#pragma omp barrier
    if(rank==1){
      result2=3;
<ompts:orphan>
<ompts:check>#pragma omp flush(result2)</ompts:check><ompts:crosscheck></ompts:crosscheck>
      dummy=result2;
</ompts:orphan>
    }
    
    if(rank==0){
      my_sleep(1.);
<ompts:orphan>
<ompts:check>#pragma omp flush(result2)</ompts:check><ompts:crosscheck></ompts:crosscheck>
      result1=result2;
</ompts:orphan>
    }
  }
  return ( (result1==result2) && (result2==dummy) && (result2==3) );
}
</ompts:testcode>
</ompts:test>
