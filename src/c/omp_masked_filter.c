<ompts:test>
<ompts:testdescription>Test which checks the filter clause of the omp masked directive by counting up a variable and checking the executing thread of the masked section.</ompts:testdescription>
<ompts:ompversion>5.1</ompts:ompversion>
<ompts:directive>omp master</ompts:directive>
<ompts:dependences>omp critical</ompts:dependences>
<ompts:testcode>
#include <stdio.h>
#include "omp_testsuite.h"

int <ompts:testcode:functionname>omp_masked_filter</ompts:testcode:functionname>(FILE * logFile)
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
	    #pragma omp masked <ompts:check>filter(1)</ompts:check>
	    {
#pragma omp critical
		{
		    nthreads++;
		}
		executing_thread = omp_get_thread_num ();

	    } /* end of master*/
	</ompts:orphan>
    } /* end of parallel*/
    return ((nthreads == 1) && (executing_thread == 1));
}
</ompts:testcode>
</ompts:test>
