<ompts:test>
<ompts:testdescription>Test which checks the omp single directive.</ompts:testdescription>
<ompts:ompversion>2.0</ompts:ompversion>
<ompts:directive>omp single</ompts:directive>
<ompts:dependences>omp parallel private,omp flush</ompts:dependences>
<ompts:testcode>
#include <stdio.h>
#include "omp_testsuite.h"

int <ompts:testcode:functionname>omp_single</ompts:testcode:functionname>(FILE * logFile)
{
	int nr_threads_in_single=0;
	int result=0;
	int nr_iterations=0;
	int i;
#pragma omp parallel private(i)
	{
		for (i=0;i<LOOPCOUNT;i++)
		{
			<ompts:check>#pragma omp single </ompts:check><ompts:crosscheck></ompts:crosscheck>
			{  
#pragma omp flush
				nr_threads_in_single++;
#pragma omp flush                         
				nr_iterations++;
				nr_threads_in_single--;
				result=result+nr_threads_in_single;
			}                          /* end of single*/    
		}                           /* end of for  */
	}                             /* end of parallel */
	return(result==0)&&(nr_iterations==LOOPCOUNT);
}                                /* end of check_single*/
</ompts:testcode>
</ompts:test>
