
#include "omp_testsuite.h"
#include <stdlib.h>
#include <stdio.h>
#include <omp.h>

static int sum0=0;
#pragma omp threadprivate(sum0)

static int myvalue=0;
#pragma omp threadprivate(myvalue)

int check_omp_threadprivate()
{
  int sum=0;
  int known_sum;
  int i;

  int iter;

  int *data;
  int size;
  int failed=0;
  int my_random;
  omp_set_dynamic(0);

#pragma omp parallel 
 {
   sum0=0;
#pragma omp for 
  for (i=1;i<=LOOPCOUNT;i++)
    {
      sum0=sum0+i;
    }                       /*end of for*/
#pragma omp critical
  {
    sum= sum+sum0;
  }                         /*end of critical*/
 }                          /* end of parallel*/    
  known_sum=(LOOPCOUNT*(LOOPCOUNT+1))/2;
  if (known_sum != sum ) {
    printf(" known_sum = %d , sum = %d \n",known_sum,sum);
  }


  /* the next parallel region is just used to get the number of threads*/
  omp_set_dynamic(0);
#pragma omp parallel
 {
   #pragma omp master
   {
     size=omp_get_num_threads();
     data=(int*) malloc(size*sizeof(int));
   }
 }/* end parallel*/

 
  srand(45);
  for (iter=0; iter<100; iter++){
    my_random=rand();/* random number generator is called inside serial region*/

    /* the first parallel region is used to initialiye myvalue and the array with my_random+rank*/
#pragma omp parallel
    {
	int rank;
	rank=omp_get_thread_num();
	myvalue=data[rank]=my_random+rank;
    }

    /* the second parallel region verifies that the value of "myvalue" is retained */
#pragma omp parallel reduction(+:failed)
    {
	int rank;
	rank=omp_get_thread_num();
	failed = failed + (myvalue != data[rank]);
	if(myvalue != data[rank]){
	    printf(" myvalue = %d, data[rank]= %d\n",myvalue,data[rank]);
      }
    }
  }
  free (data);

  return (known_sum==sum) && !failed;

}/* end of check_threadprivate*/




static int crosssum0=0;
/*#pragma omp threadprivate(crosssum0)*/

static int crossmyvalue=0;
/*#pragma omp threadprivate(crossmyvalue)*/

int crosscheck_omp_threadprivate()
{
  int sum=0;
  int known_sum;
  int i;

  int iter;

  int *data;
  int size;
  int failed=0;
  int my_random;
  omp_set_dynamic(0);

#pragma omp parallel 
 {
   crosssum0=0;
#pragma omp for 
  for (i=1;i<LOOPCOUNT;i++)
    {
      crosssum0=crosssum0+i;
    }                       /*end of for*/
#pragma omp critical
  {
    sum= sum+crosssum0;
  }                         /*end of critical*/
 }                          /* end of parallel*/    
  known_sum=(LOOPCOUNT*(LOOPCOUNT+1))/2;



#pragma omp parallel
 {
   #pragma omp master
   {
     size=omp_get_num_threads();
     data=(int*) malloc(size*sizeof(int));
   }
 }
  srand(45);
  for (iter=0; iter<100; iter++){
    my_random=rand();
#pragma omp parallel
    {
	int rank;
	rank=omp_get_thread_num();
	crossmyvalue=data[rank]=my_random+rank;
    }
#pragma omp parallel reduction(+:failed)
    {
	int rank;
	rank=omp_get_thread_num();
	failed = failed + (crossmyvalue != data[rank]);
    }
  }
  free (data);

  return (known_sum==sum) && !failed;

}/* end of crosscheck_threadprivate*/






static int sum1=789;
#pragma omp threadprivate(sum1)

int check_omp_copyin()
{
  int sum=0;
  int known_sum;
  int i;
  sum1=0;
#pragma omp parallel copyin(sum1)
 {
   /*printf("sum1=%d\n",sum1);*/
#pragma omp for 
  for (i=1;i<1000;i++)
    {
      sum1=sum1+i;
    }                       /*end of for*/
#pragma omp critical
  {
    sum= sum+sum1;
  }                         /*end of critical*/
 }                          /* end of parallel*/    
  known_sum=(999*1000)/2;
  return (known_sum==sum);

}/* end of check_threadprivate*/

static int crosssum1=789;
#pragma omp threadprivate(crosssum1)

int crosscheck_omp_copyin()
{
  int sum=0;
  int known_sum;
  int i;
  crosssum1=0;
#pragma omp parallel
 {
   /*printf("sum1=%d\n",sum1);*/
#pragma omp for 
  for (i=1;i<1000;i++)
    {
      crosssum1=crosssum1+i;
    }                       /*end of for*/
#pragma omp critical
  {
    sum= sum+crosssum1;
  }                         /*end of critical*/
 }                          /* end of parallel*/    
  known_sum=(999*1000)/2;
  return (known_sum==sum);

}/* end of check_threadprivate*/



/*#pragma omp threadprivate(sum0)
int check_omp_copyprivate()
{
  int sum=0;
  int known_sum;
  int i;
#pragma omp parallel 
  {
    for (i=1;i<1000;i++)
      {
#pragma omp single copyprivate(sum0) 
	{
	  sum0=sum0+i;
	} 
      

#pragma omp critical
    {
      sum= sum+sum0;
    }                        
}                     
      }                   
  known_sum=(999*1000)/2;
  return (known_sum==sum);
  
}*/




static int myvalue2=0;


int crosscheck_spmd_threadprivate(){
  int iter;

  int *data;
  int size;
  int failed=0;
  int my_random;
  omp_set_dynamic(0);
  
#pragma omp parallel
 {
   #pragma omp master
   {
     size=omp_get_num_threads();
     data=(int*) malloc(size*sizeof(int));
   }
 }
  srand(45);
  for (iter=0; iter<100; iter++){
    my_random=rand();
#pragma omp parallel
    {
	int rank;
	rank=omp_get_thread_num();
	myvalue2=data[rank]=my_random+rank;
    }
#pragma omp parallel reduction(+:failed)
    {
	int rank;
	rank=omp_get_thread_num();
	failed = failed + (myvalue2 != data[rank]);
    }
  }
  free (data);
  return !failed;
}




