<ompts:test>
<ompts:testdescription>Test which checks the omp parallel copyin directive.</ompts:testdescription>
<ompts:ompversion>2.0</ompts:ompversion>
<ompts:directive>omp parallel copyin</ompts:directive>
<ompts:dependences>omp critical,omp threadprivate</ompts:dependences>
<ompts:testcode>
#include "omp_testsuite.h"
#include <stdlib.h>
#include <stdio.h>
#include <omp.h>

static int sum1=789;
#pragma omp threadprivate(sum1)

int <ompts:testcode:functionname>omp_parallel_copyin</ompts:testcode:functionname>(FILE * logFile)
{
	int sum=0;
	int known_sum;
	int i;
	sum1=0;
#pragma omp parallel <ompts:check>copyin(sum1)</ompts:check><ompts:crosscheck></ompts:crosscheck>
	{
		/*printf("sum1=%d\n",sum1);*/
#pragma omp for 
		for (i=1;i<1000;i++)
		{
			sum1=sum1+i;
		}                       /*end of for*/
#pragma omp critical
		{
			sum = sum+sum1;
		}                         /*end of critical*/
	}                          /* end of parallel*/    
	known_sum=(999*1000)/2;
	return (known_sum==sum);

}
</ompts:testcode>
</ompts:test>
