<ompts:test>
<ompts:testdescription>Test which checks the omp critical directive by counting up a variable in a parallelized loop within a critical section.</ompts:testdescription>
<ompts:ompversion>2.0</ompts:ompversion>
<ompts:directive>omp critical</ompts:directive>
<ompts:testcode>
#include <stdio.h>
#include "omp_testsuite.h"

int <ompts:testcode:functionname>omp_critical</ompts:testcode:functionname>(FILE * logFile)
{
  int i;
  int sum=0;
  int known_sum;
#pragma omp parallel
  {
#pragma omp for
    for(i=0;i<1000;i++)
      {
<ompts:check>#pragma omp critical</ompts:check><ompts:crosscheck></ompts:crosscheck>
	{
	  sum=sum+i;
	}
      }
  }
  known_sum=999*1000/2;
  return(known_sum==sum);
}
</ompts:testcode>
</ompts:test>
