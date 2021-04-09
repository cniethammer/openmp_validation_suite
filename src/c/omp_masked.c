<ompts:test>
<ompts:testdescription>Test which checks the omp masked directive by counting up a variable in a omp masked section.</ompts:testdescription>
<ompts:ompversion>5.1</ompts:ompversion>
<ompts:directive>omp masked</ompts:directive>
<ompts:dependences>omp critical</ompts:dependences>
<ompts:testcode>
#include <stdio.h>
#include "omp_testsuite.h"

/*
 * TODO not checked up to now: no implied barrier, check threads of team
 */
int <ompts:testcode:functionname>omp_masked</ompts:testcode:functionname>(FILE * logFile)
{
    <ompts:orphan:vars>
	int nthreads;
	int executing_thread;
    </ompts:orphan:vars>

    nthreads = 0;
    executing_thread = -1;

#pragma omp parallel
    {
	<ompts:orphan>
	    <ompts:check>#pragma omp masked</ompts:check>
	    {
#pragma omp critical
		{
		    nthreads++;
		}
		executing_thread = omp_get_thread_num();

	    } /* end of master*/
	</ompts:orphan>
    } /* end of parallel*/
    printf("Number of threads in block: %d\n", nthreads);
    printf("Executing thread: %d\n", executing_thread);
    return ((nthreads == 1) && (executing_thread == 0));
}
</ompts:testcode>
</ompts:test>
