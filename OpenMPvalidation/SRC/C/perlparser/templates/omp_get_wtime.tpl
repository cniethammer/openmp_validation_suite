<ompts:test>
<ompts:testdescription>Test which checks the omp_check_time function. It compares the time with which is called a sleep function with the time it took by messuring the difference between the call of the sleep function and its end.</ompts:testdescription>
<ompts:ompversion>2.0</ompts:ompversion>
<ompts:directive>omp_get_wtime</ompts:directive>
<ompts:testcode>
#include<stdio.h>
#include<omp.h>
#include<stdlib.h>
#include<unistd.h>


#include "omp_testsuite.h"
#include "omp_my_sleep.h"

int <ompts:testcode:functionname>omp_get_wtime</ompts:testcode:functionname>(FILE * logFile)
{
  double start=0;
  double end=0;
  int wait_time=1; 
  double measured_time;
  <ompts:check>start=omp_get_wtime();</ompts:check><ompts:crosscheck></ompts:crosscheck>
  my_sleep(wait_time); 
  <ompts:check>end=omp_get_wtime();</ompts:check><ompts:crosscheck></ompts:crosscheck>
  measured_time=end-start;
  fprintf(logFile,"work took %f sec. time. \n",measured_time);
  return (measured_time>0.99*wait_time) && (measured_time<1.01*wait_time) ;
}
</ompts:testcode>
</ompts:test>
