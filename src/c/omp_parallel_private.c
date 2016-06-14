<ompts:test>
<ompts:testdescription>Test which checks the omp parallel private directive.</ompts:testdescription>
<ompts:ompversion>3.0</ompts:ompversion>
<ompts:directive>omp parallel private</ompts:directive>
<ompts:dependences>omp for omp critical</ompts:dependences>
<ompts:testcode>
#include <stdio.h>
#include <stdlib.h>
#include "omp_testsuite.h"

//static int sum1 = 789;

int <ompts:testcode:functionname>omp_parallel_private</ompts:testcode:functionname>(FILE * logFile)
{
    <ompts:orphan:vars>
	int sum, num_threads,sum1;
    </ompts:orphan:vars>
    int known_sum;  
    
    sum = 0; 
    <ompts:crosscheck> sum1=0; </ompts:crosscheck>
    num_threads = 0;

<ompts:orphan>
        printf("before parallel sum1(%p)=%d \n",&sum1, sum1);
#pragma omp parallel <ompts:check>private(sum1)</ompts:check>
    {
        <ompts:check>
	sum1 = 7;
	</ompts:check>
        printf("before loop sum1(%p)=%d for thread %d\n",&sum1, sum1, omp_get_thread_num());
	int i;
#pragma omp for 
	    for (i = 1; i < 1000; i++)
	    {
		sum1 = sum1 + i;
	    } /*end of for*/
        printf("after loop sum1(%p)=%d for thread %d\n",&sum1, sum1, omp_get_thread_num());
#pragma omp critical
	{
	    sum = sum + sum1;
            num_threads++;
	} /*end of critical*/
    } /* end of parallel*/    
</ompts:orphan>

    known_sum = (999 * 1000) / 2 + 7 * num_threads;
    return (known_sum == sum);

}
</ompts:testcode>
</ompts:test>
