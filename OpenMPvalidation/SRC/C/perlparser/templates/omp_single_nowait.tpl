<ompts:test>
<ompts:testdescription></ompts:testdescription>
<ompts:ompversion>2.0</ompts:ompversion>
<ompts:directive>omp single nowait</ompts:directive>
<ompts:dependences>omp critical,omp atomic</ompts:dependences>
<ompts:testcode>
#include <stdio.h>
#include "omp_testsuite.h"

int <ompts:testcode:functionname>omp_single_nowait</ompts:testcode:functionname>(FILE * logFile)
{
  int nr_iterations=0;
  int total_iterations=0;
  int my_iterations=0;
  int i;
#pragma omp parallel private(i)
  {
    for (i=0;i<LOOPCOUNT;i++)
      {
<ompts:check>#pragma omp single nowait</ompts:check><ompts:crosscheck></ompts:crosscheck>
		  {
#pragma omp atomic  
			  nr_iterations++;
		  }                          /* end of single*/    
      }                           /* end of for  */
  }                             /* end of parallel */

#pragma omp parallel private(i,my_iterations) 
  {
	  my_iterations=0;
	  for (i=0;i<LOOPCOUNT;i++)
	  {
<ompts:check>#pragma omp single nowait</ompts:check><ompts:crosscheck></ompts:crosscheck>
		  {
			  my_iterations++;
		  }                          /* end of single*/    
	  }                           /* end of for  */
#pragma omp critical
	  {
		  total_iterations += my_iterations;
	  }

  }                             /* end of parallel */
  return((nr_iterations==LOOPCOUNT) && (total_iterations==LOOPCOUNT));
}                                /* end of check_single_nowait*/
</ompts:testcode>
</ompts:test>
