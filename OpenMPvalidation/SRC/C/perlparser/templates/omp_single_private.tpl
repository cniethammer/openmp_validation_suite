<ompts:test>
<ompts:testdescription>Test which checks the omp single private directive.</ompts:testdescription>
<ompts:ompversion>2.0</ompts:ompversion>
<ompts:directive>omp singel private</ompts:directive>
<ompts:dependences>omp critical,omp flush,omp single nowait</ompts:dependences>
<ompts:testcode>
#include <stdio.h>
#include "omp_testsuite.h"

int <ompts:testcode:functionname>omp_single_private</ompts:testcode:functionname>(FILE * logFile)
{
  int nr_threads_in_single=0;
  int result=0;
  int myresult=0;
  int myit=0;
  int nr_iterations=0;
  int i;
#pragma omp parallel private(i,myresult,myit)
  {
    myresult=0;
    myit=0;
    for (i=0;i<LOOPCOUNT;i++)
      {
#pragma omp single <ompts:check>private(nr_threads_in_single) </ompts:check><ompts:crosscheck></ompts:crosscheck>nowait
	{  
	  nr_threads_in_single=0;
#pragma omp flush
	  nr_threads_in_single++;
#pragma omp flush                         
	  myit++;
	  nr_threads_in_single--;
	  myresult=myresult+nr_threads_in_single;
	}                          /* end of single*/    
      }                            /* end of for  */
#pragma omp critical
    {
      result += myresult;
      nr_iterations += myit;
    }
  }                               /* end of parallel */
  return(result==0)&&(nr_iterations==LOOPCOUNT);
}                                   /* end of check_single private*/ 
</ompts:testcode>
</ompts:test>