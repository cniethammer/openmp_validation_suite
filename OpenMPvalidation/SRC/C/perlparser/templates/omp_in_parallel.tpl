<ompts:test>
<ompts:testdescription>Test which checks that omp_in_parallel returns false when called from serial region and true when called within a parallel region.</ompts:testdescription>
<ompts:ompversion>2.0</ompts:ompversion>
<ompts:directive>omp_in_parallel</ompts:directive>
<ompts:testcode>
#include <stdio.h>
#include "omp.h"
#include "omp_testsuite.h"

int <ompts:testcode:functionname>ompf_omp_in_parallel</ompts:testcode:functionname>(FILE * logFile){
  int serial=1;
  int isparallel=0;
<ompts:check>
  serial=omp_in_parallel();
#pragma omp parallel
  {
#pragma omp single
    {
      isparallel=omp_in_parallel();
    }
  }
</ompts:check>
<ompts:crosscheck>
#pragma omp parallel
  {
#pragma omp single
    {
		
    }
  }
</ompts:crosscheck>
  return ( !(serial) && isparallel );
}
</ompts:testcode>
</ompts:test>
