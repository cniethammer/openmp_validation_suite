<ompts:test>
<ompts:testdescription>Test which checks the omp parallel for ordered directive</ompts:testdescription>
<ompts:ompversion>2.0</ompts:ompversion>
<ompts:directive>omp parallel for ordered</ompts:directive>
<ompts:dependences>omp parallel schedule(static)</ompts:dependences>
<ompts:testcode>
#include <stdio.h>
#include <omp.h>
#include "omp_testsuite.h"

static int last_i=0;

/*! 
  Utility function: returns true if the passed argument is larger than 
  the argument of the last call of this function.
  */
static int check_i_islarger2(int i){
	int islarger;
	islarger=(i>last_i);
	last_i=i;
	return (islarger);
}

int <ompts:testcode:functionname>parallel_for_ordered</ompts:testcode:functionname>(FILE * logFile){
	int sum=0;
	int known_sum;
	int i;
	int is_larger=1;
	last_i=0;
#pragma omp parallel for schedule(static,1) <ompts:check>ordered</ompts:check><ompts:crosscheck></ompts:crosscheck>
	for (i=1;i<100;i++)
	{
<ompts:check>#pragma omp ordered</ompts:check><ompts:crosscheck></ompts:crosscheck>
		{
			is_larger= check_i_islarger2(i) && is_larger;
			sum=sum+i;
		}
	}
	known_sum=(99*100)/2;
	return (known_sum==sum) && is_larger;
}
</ompts:testcode>
</ompts:test>
