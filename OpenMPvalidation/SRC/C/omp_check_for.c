
/* This file contains all checks for the for construct:

   ordered: checks that the execution is equivalent to the serial case


 */

#include <math.h>
#include "omp_testsuite.h"

static int last_i=0;

int check_i_islarger(int i){
  int islarger;
  islarger=(i>last_i);
  last_i=i;
  return (islarger);
}

int check_for_ordered(){
  int sum=0;
  int known_sum;
  int i;
  int my_islarger;
  int is_larger=1;
  last_i=0;
#pragma omp parallel private(my_islarger) 
 {
   my_islarger=1;
#pragma omp for schedule(static,1) ordered
  for (i=1;i<100;i++)
    {
#pragma omp ordered
      {
      my_islarger= check_i_islarger(i) && my_islarger;
      sum=sum+i;
      }
    }
  #pragma omp critical
  {
    is_larger = is_larger && my_islarger;
  }
 }
  known_sum=(99*100)/2;
  return (known_sum==sum) && is_larger;
}

int crosscheck_for_ordered(){
  int sum=0;
  int known_sum;
  int i;
  int my_islarger;
  int is_larger=1;
  last_i=0;
#pragma omp parallel private(my_islarger) 
 {
   my_islarger=1;
#pragma omp for schedule(static,1) 
  for (i=1;i<100;i++)
    {
      {
      my_islarger= check_i_islarger(i) && my_islarger;
      sum=sum+i;
      }
    }
  #pragma omp critical
  {
    is_larger = is_larger && my_islarger;
  }
 }
  known_sum=(99*100)/2;
  return (known_sum==sum) && is_larger;
}

int check_for_reduction(){
  int sum=0;
  int sum2=0;

  int known_sum;
  int i,i2;
  /*  int my_islarger;*/
  /*  int is_larger=1;*/
#pragma omp parallel 
 {
#pragma omp for schedule(dynamic,1) reduction(+:sum)
  for (i=1;i<=LOOPCOUNT;i++)
    {
      sum=sum+i;
    }
 }


#pragma omp parallel 
 {
#pragma omp for schedule(static,1) reduction(+:sum2)
  for (i2=1;i2<=LOOPCOUNT;i2++)
    {
      sum2=sum2+i2;
    }
 }
  known_sum=(LOOPCOUNT*(LOOPCOUNT+1))/2;
  return ( (known_sum==sum) && (known_sum==sum2) ) ;
}

int crosscheck_for_reduction(){
  int sum=0;
  int sum2=0;

  int known_sum;
  int i,i2;
  /*  int my_islarger;*/
  /*  int is_larger=1;*/
#pragma omp parallel 
 {
#pragma omp for schedule(dynamic,1)
  for (i=1;i<=LOOPCOUNT;i++)
    {
      sum=sum+i;
    }
 }


#pragma omp parallel 
 {
#pragma omp for schedule(static,1) 
  for (i2=1;i2<=LOOPCOUNT;i2++)
    {
      sum2=sum2+i2;
    }
 }
  known_sum=(LOOPCOUNT*(LOOPCOUNT+1))/2;
  return ( (known_sum==sum) && (known_sum==sum2) ) ;
}


void do_some_work(){
  int i;
  double sum=0;
  for(i=0;i++;i<LOOPCOUNT){
    sum+=sqrt(i);
  }
}

int check_for_private(){
  int sum=0;
  int sum0=0;
  int sum1=0;
  int known_sum;
  int i;
#pragma omp parallel private(sum1)
 {
   sum0=0;
   sum1=0;
#pragma omp for private(sum0) schedule(static,1)
  for (i=1;i<=LOOPCOUNT;i++)
    {
      sum0=sum1;
#pragma omp flush
      sum0=sum0+i;
      do_some_work();
#pragma omp flush
      sum1=sum0;
    }                       /*end of for*/
#pragma omp critical
  {
    sum= sum+sum1;
  }                         /*end of critical*/
 }                          /* end of parallel*/    
  known_sum=(LOOPCOUNT*(LOOPCOUNT+1))/2;
  return (known_sum==sum);
}                                /* end of check_for_private*/

int crosscheck_for_private(){
  int sum=0;
  int sum0=0;
  int sum1=0;
  int known_sum;
  int i;
#pragma omp parallel private(sum1)
 {
   sum0=0;
   sum1=0;
#pragma omp for schedule(static,1)
  for (i=1;i<=LOOPCOUNT;i++)
    {
      sum0=sum1;
#pragma omp flush
      sum0=sum0+i;
      do_some_work();
#pragma omp flush
      sum1=sum0;
    }                       /*end of for*/
#pragma omp critical
  {
    sum= sum+sum1;
  }                         /*end of critical*/
 }                          /* end of parallel*/    
  known_sum=(LOOPCOUNT*(LOOPCOUNT+1))/2;
  return (known_sum==sum);
}                                /* end of check_for_private*/

int check_for_firstprivate(){
  int sum=0;
  int sum0=0;
  int sum1=0;
  int known_sum;
  int i;
#pragma omp parallel firstprivate(sum1)
 {
   /*sum0=0;*/
#pragma omp for firstprivate(sum0) 
  for (i=1;i<=LOOPCOUNT;i++)
    {
      sum0=sum0+i;
      sum1=sum0;
    }                       /*end of for*/
#pragma omp critical
  {
    sum= sum+sum1;
  }                         /*end of critical*/
 }                          /* end of parallel*/    
  known_sum=(LOOPCOUNT*(LOOPCOUNT+1))/2;
  return (known_sum==sum);
}                                /* end of check_for_fistprivate*/

int crosscheck_for_firstprivate(){
  int sum=0;
  int sum0=0;
  int sum1=0;
  int known_sum;
  int i;
#pragma omp parallel firstprivate(sum1)
 {
   /*sum0=0;*/
#pragma omp for
  for (i=1;i<=LOOPCOUNT;i++)
    {
      sum0=sum0+i;
      sum1=sum0;
    }                       /*end of for*/
#pragma omp critical
  {
    sum= sum+sum1;
  }                         /*end of critical*/
 }                          /* end of parallel*/    
  known_sum=(LOOPCOUNT*(LOOPCOUNT+1))/2;
  return (known_sum==sum);
}                                /* end of check_for_fistprivate*/

int check_for_lastprivate(){
  int sum=0;
  int sum0=0;
  int known_sum;
  int i;
  int i0=-1;
#pragma omp parallel firstprivate(sum0) 
 {
   /*sum0=0;*/
#pragma omp for schedule(static,7) lastprivate(i0)
  for (i=1;i<=LOOPCOUNT;i++)
    {
      sum0=sum0+i;
      i0=i;
    }                       /*end of for*/
#pragma omp critical
  {
    sum= sum+sum0;
  }                         /*end of critical*/
 }                          /* end of parallel*/    
  known_sum=(LOOPCOUNT*(LOOPCOUNT+1))/2;
  return ((known_sum==sum) && (i0==LOOPCOUNT) );
}                                /* end of check_for_lastprivate*/

int crosscheck_for_lastprivate(){
  int sum=0;
  int sum0=0;
  int known_sum;
  int i;
  int i0=-1;
#pragma omp parallel firstprivate(sum0) 
 {
   /*sum0=0;*/
#pragma omp for schedule(static,7) 
  for (i=1;i<=LOOPCOUNT;i++)
    {
      sum0=sum0+i;
      i0=i;
    }                       /*end of for*/
#pragma omp critical
  {
    sum= sum+sum0;
  }                         /*end of critical*/
 }                          /* end of parallel*/    
  known_sum=(LOOPCOUNT*(LOOPCOUNT+1))/2;
  return ((known_sum==sum) && (i0==LOOPCOUNT) );
}                                /* end of check_for_lastprivate*/
