#include "omp_testsuite.h"
#include <omp.h>
#include <stdio.h>

#define MAX_SIZE 1000

int check_for_schedule()
{
  int i;
  int rank;
  int a[MAX_SIZE];
  
#pragma omp parallel private(rank)
  {
    rank=omp_get_thread_num();
#pragma omp for schedule(static) 
    
    for(i=0;i<MAX_SIZE;i++)
      {
	a[i]=rank;
      }
    
  }/* end of parallel */
  for(i=0;i<MAX_SIZE;i++)
    {
      printf("a[%d]= %d \n",i,a[i]); 
    }
 
}

/* a subroutine for finding num of chunks,thread number,and the chunk-size*/

/*function()
{
  int a[Max_SIZE];*/

