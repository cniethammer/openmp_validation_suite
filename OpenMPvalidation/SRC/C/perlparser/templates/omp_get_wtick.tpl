<ompts:test>
<ompts:testdescription>Test which checks the omp_get_wtick function.</ompts:testdescription>
<ompts:ompversion>2.0</ompts:ompversion>
<ompts:directive>omp_get_wtick</ompts:directive>
<ompts:testcode>
#include<stdio.h>
#include<omp.h>

#include "omp_testsuite.h"

int <ompts:testcode:functionname>ompf_omp_get_wtick</ompts:testcode:functionname>(FILE * logFile)
{
  double tick;
  <ompts:check>tick=omp_get_wtick();</ompts:check><ompts:crosscheck></ompts:crosscheck>
  fprintf(logFile,"work took %f sec. time. \n",tick);
  return ( tick>0.0) && (tick<0.01);
}
</ompts:testcode>
</ompts:test>
