<ompts:test>
<ompts:testdescription>Test which checks the omp master directive by counting up a variable in a omp master section.</ompts:testdescription>
<ompts:ompversion>2.0</ompts:ompversion>
<ompts:directive>omp master</ompts:directive>
<ompts:dependences>omp critical</ompts:dependences>
<ompts:testcode>
#include <stdio.h>
#include <omp.h>
#include "omp_testsuite.h"

int <ompts:testcode:functionname>omp_master</ompts:testcode:functionname>(FILE * logFile)
{
  int nthreads=0;
  int executing_thread=-1;
#pragma omp parallel
  {
<ompts:check>#pragma omp master </ompts:check><ompts:crosscheck></ompts:crosscheck>
    {
#pragma omp critical
      {
	nthreads++;
      }
      executing_thread=omp_get_thread_num();
      
    }/* end of master*/
  }/* end of parallel*/
  return ((nthreads==1) && (executing_thread==0 ));
}
</ompts:testcode>
</ompts:test>
