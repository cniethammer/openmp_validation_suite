
/* This file contains all checks for the single  construct: */

#include <stdio.h>
#include "omp_testsuite.h"


int check_single(FILE * logFile)
{
  int nr_threads_in_single=0;
  int result=0;
  int nr_iterations=0;
  int i;
#pragma omp parallel private(i)
  {
    for (i=0;i<LOOPCOUNT;i++)
      {
#pragma omp single 
	{  
#pragma omp flush
	  nr_threads_in_single++;
#pragma omp flush                         
	  nr_iterations++;
	  nr_threads_in_single--;
	  result=result+nr_threads_in_single;
	}                          /* end of single*/    
      }                           /* end of for  */
  }                             /* end of parallel */
  return(result==0)&&(nr_iterations==LOOPCOUNT);
}                                /* end of check_single*/

int crosscheck_single(FILE * logFile)
{
  int nr_threads_in_single=0;
  int result=0;
  int nr_iterations=0;
  int i;
#pragma omp parallel private(i)
  {
    for (i=0;i<LOOPCOUNT;i++)
      {

	{  
#pragma omp flush
	  nr_threads_in_single++;
#pragma omp flush                         
	  nr_iterations++;
	  nr_threads_in_single--;
	  result=result+nr_threads_in_single;
	}                          /* end of single*/    
      }                           /* end of for  */
  }                             /* end of parallel */
  return(result==0)&&(nr_iterations==LOOPCOUNT);
}                                /* end of check_single*/

int check_single_private(FILE * logFile)
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
#pragma omp single private(nr_threads_in_single) nowait
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

int crosscheck_single_private(FILE * logFile)
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
#pragma omp single nowait
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


/*int check_single_copyprivate()                                   
{
  int nr_threads_in_single=0;
  int result=0;
  int result2=0;
  int nr_iterations=0;
  int i,j;
#pragma omp parallel private(i,j)
  {
    for (i=0;i<LOOPCOUNT;i++)
      {
#pragma omp single copyprivate(j)  
	
#pragma omp flush
	nr_threads_in_single++;
#pragma omp flush                         
	nr_iterations++;
	nr_threads_in_single--;
	result=result+nr_threads_in_single;
	j=result;
	
      }
  } 
  return(j==0)&&(nr_iterations==LOOPCOUNT);
}*/

int check_single_nowait(FILE * logFile)
{
  int result=0;
  int nr_iterations=0;
  int total_iterations=0;
  int my_iterations=0;
  int i;
#pragma omp parallel private(i)
  {
    for (i=0;i<LOOPCOUNT;i++)
      {
#pragma omp single nowait
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
#pragma omp single nowait
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


int crosscheck_single_nowait(FILE * logFile)
{
  int result=0;
  int nr_iterations=0;
  int total_iterations=0;
  int my_iterations=0;
  int i;
#pragma omp parallel private(i)
  {
    for (i=0;i<LOOPCOUNT;i++)
      {

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


