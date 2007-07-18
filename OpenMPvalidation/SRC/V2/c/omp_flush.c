<ompts:test>
<ompts:testdescription>Test which checks the omp flush directive.</ompts:testdescription>
<ompts:ompversion>2.0</ompts:ompversion>
<ompts:directive>omp flush</ompts:directive>
<ompts:dependences>omp barrier</ompts:dependences>
<ompts:testcode>
#include <stdio.h>
#include <unistd.h>

#include "omp_testsuite.h"
#include "omp_my_sleep.h"

int <ompts:testcode:functionname>omp_flush</ompts:testcode:functionname> (FILE * logFile)
{
    <ompts:orphan:vars>
	int sum1;
	int sum2;
        int i;
    </ompts:orphan:vars>

    sum1 = 0;
    sum2 = 0;

#pragma omp parallel
    {
	int rank;
	rank = omp_get_thread_num ();

#pragma omp barrier
	if (rank == 1) {
	    <ompts:orphan>
                for (i = 0; i <= 10000; i++) {
                    <ompts:check>#pragma omp flush (sum2)</ompts:check>
                    sum1 = sum2 + i;
                }
	    </ompts:orphan>
	}

	if (rank == 0) {
	    <ompts:orphan>
                for (i = 0; i <= 10000; i++) {
		    <ompts:check>#pragma omp flush (sum1)</ompts:check>
                    sum2 = sum1 + i;
                }
	    </ompts:orphan>
	}
    }	/* end of parallel */

    return ((sum1 > 100000) && (sum2 > 100000));
}
</ompts:testcode>
</ompts:test>
