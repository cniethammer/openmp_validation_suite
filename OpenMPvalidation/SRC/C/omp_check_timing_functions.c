#include<stdio.h>
#include<omp.h>
#include<stdlib.h>
#include<unistd.h>


#include "omp_testsuite.h"
#include "omp_my_sleep.h"

int omp_check_time(FILE * logFile)
{
  double start=0;
  double end=0;
  int wait_time=1; 
  double measured_time;
  start=omp_get_wtime();
  my_sleep(wait_time); 
  end=omp_get_wtime();
  measured_time=end-start;
  fprintf(logFile,"work took %f sec. time. \n",measured_time);
  return (measured_time>0.99*wait_time) && (measured_time<1.01*wait_time) ;
}

int omp_crosscheck_time(FILE * logFile)
{
  double start=0;
  double end=0;
  int wait_time=1; 
  double measured_time;
  /*start=omp_get_wtime();*/
  my_sleep(wait_time); 
  /*end=omp_get_wtime();*/
  measured_time=end-start;
  fprintf(logFile,"work took %f sec. time. \n",measured_time);
  return (measured_time>0.99*wait_time) && (measured_time<1.01*wait_time) ;
}



int omp_check_ticks_time(FILE * logFile)
{
  double tick;
  tick=omp_get_wtick();
  fprintf(logFile,"work took %f sec. time. \n",tick);
  return ( tick>0.0) && (tick<0.01);
}

int omp_crosscheck_ticks_time(FILE * logFile)
{
  double tick=0;
  /*tick=omp_get_wtick();*/
  fprintf(logFile,"work took %f sec. time. \n",tick);
  return ( tick>0.0) && (tick<0.01);
}
