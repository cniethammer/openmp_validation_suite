<ompts:test>
<ompts:testdescription>Test which checks the omp atomic directive by counting up a variable in a parallelized loop with an atomic directive.</ompts:testdescription>
<ompts:ompversion>2.0</ompts:ompversion>
<ompts:directive>omp atomic</ompts:directive>
<ompts:testcode>
#include <stdio.h>
#include <unistd.h>
#include <omp.h>
#include "omp_testsuite.h"
#include "omp_my_sleep.h"

int <ompts:testcode:functionname>omp_atomic</ompts:testcode:functionname>(FILE * logFile)
{
  int i;
  int sum=0;
  int known_sum;
#pragma omp parallel
  {
#pragma omp for
    for(i=0;i<1000;i++)
      {
<ompts:check>#pragma omp atomic</ompts:check><ompts:crosscheck></ompts:crosscheck>
	  sum+=i;
      }
  }
    known_sum=999*1000/2;
    return(known_sum==sum);
}
</ompts:testcode>
</ompts:test>
