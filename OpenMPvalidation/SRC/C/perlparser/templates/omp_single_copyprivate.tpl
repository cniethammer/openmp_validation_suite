<ompts:test>
<ompts:testdescription>Test which checks the omp single copyprivate directive.</ompts:testdescription>
<ompts:ompversion>2.0</ompts:ompversion>
<ompts:directive>omp single copyprivate</ompts:directive>
<ompts:dependences>omp parllel private,omp critical</ompts:dependences>
<ompts:testcode>
#include <omp.h>
#include "omp_testsuite.h"

int <ompts:testcode:functionname>omp_single_copyprivate</ompts:testcode:functionname>(FILE * logFile)                                   
{
    int result = 0;
    int nr_iterations = 0;
    int i;
#pragma omp parallel private(i)
    {
	for (i = 0; i < LOOPCOUNT; i++)
	{
	    <ompts:orphan>
		int j;
		/*
		   int thread;
		   thread = omp_get_thread_num ();
		 */
#pragma omp single <ompts:check>copyprivate(j)</ompts:check><ompts:crosscheck>private(j)</ompts:crosscheck>
		{
		    nr_iterations++;
		    j = i;
		    /*printf ("thread %d assigns, j = %d, i = %d\n", thread, j, i);*/
		}
		/*	#pragma omp barrier*/
#pragma omp critical
		{
		    /*printf ("thread = %d, j = %d, i = %d\n", thread, j, i);*/
		    result = result + j - i;
		}
	    </ompts:orphan>
#pragma omp barrier
	} /* end of for */
    } /* end of parallel */
    return ((result == 0) && (nr_iterations == LOOPCOUNT));
}
</ompts:testcode>
</ompts:test>
