#include <stdio.h>
#include <unistd.h>
#include <omp.h>
#include "omp_testsuite.h"

int check_omp_critical(FILE * logFile)
{
  int i;
  int sum=0;
  int known_sum;
#pragma omp parallel
  {
#pragma omp for
    for(i=0;i<1000;i++)
      {
#pragma omp critical
	{
	  sum=sum+i;
	}
      }
  }
  known_sum=999*1000/2;
  return(known_sum==sum);
}


int crosscheck_omp_critical(FILE * logFile)
{
  int i;
  int sum=0;
  int known_sum;
#pragma omp parallel
  {
#pragma omp for
    for(i=0;i<1000;i++)
      {

	{
	  sum=sum+i;
	}
      }
  }
  known_sum=999*1000/2;
  return(known_sum==sum);
}


int check_omp_atomic(FILE * logFile)
{
  int i;
  int sum=0;
  int known_sum;
#pragma omp parallel
  {
#pragma omp for
    for(i=0;i<1000;i++)
      {
#pragma omp atomic
	  sum+=i;
      }
  }
    known_sum=999*1000/2;
    return(known_sum==sum);
}

int crosscheck_omp_atomic(FILE * logFile)
{
  int i;
  int sum=0;
  int known_sum;
#pragma omp parallel
  {
#pragma omp for
    for(i=0;i<1000;i++)
      {

	  sum+=i;
      }
  }
    known_sum=999*1000/2;
    return(known_sum==sum);
}


int check_omp_barrier(FILE * logFile){
  int result1=0;
  int result2=0;
#pragma omp parallel
  {
    int rank;
    rank=omp_get_thread_num();
    if(rank==1){
      sleep(2);
      result2=3;
    }
    #pragma omp barrier
    if(rank==0){
      result1=result2;
    }
  }
  return (result1==3);
}

int crosscheck_omp_barrier(FILE * logFile){
  int result1=0;
  int result2=0;
#pragma omp parallel
  {
    int rank;
    rank=omp_get_thread_num();
    if(rank==1){
      sleep(2);
      result2=3;
    }

    if(rank==0){
      result1=result2;
    }
  }
  return (result1==3);
}

int check_omp_flush(FILE * logFile){
  int result1=0;
  int result2=0;
  int dummy;
#pragma omp parallel
  {

    int rank;
    rank=omp_get_thread_num();
#pragma omp barrier
    if(rank==1){
      result2=3;
#pragma omp flush(result2)
      dummy=result2;
    }
    
    if(rank==0){
      sleep(2);
#pragma omp flush(result2)
      result1=result2;
    }
  }
  return ( (result1==result2) && (result2==dummy) && ( result2==3) );
}

int crosscheck_omp_flush(FILE * logFile){
  int result1=0;
  int result2=0;
  int dummy;
#pragma omp parallel
  {

    int rank;
    rank=omp_get_thread_num();
#pragma omp barrier
    if(rank==1){
      result2=3;
#pragma omp flush(result2)
      dummy=result2;
    }
    
    if(rank==0){
      sleep(2);
#pragma omp flush(result2)
      result1=result2;
    }
  }
  return ( (result1==result2) && (result2==dummy) && ( result2==3) );
}


