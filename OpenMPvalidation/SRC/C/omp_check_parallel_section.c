/* This file contains all checks for the section construct:

   ordered: checks that the execution is equivalent to the serial case


 */


#include "omp_testsuite.h"


int check_parallel_section_reduction(){
  int sum=7;
  int known_sum;
  int i;

  
#pragma omp parallel sections reduction(+:sum) private(i)
    {
#pragma omp section
      {
	for (i=1;i<400;i++){
	  sum += i;
	}
      }
#pragma omp section
      {
	for(i=400;i<700;i++)
	  sum += i;
      }
#pragma omp section
      {
	for(i=700;i<1000;i++)
	  sum += i;
      }
      
    }/* end of section reduction.*/
 
  known_sum=(999*1000)/2+7;
  return (known_sum==sum);
}

int crosscheck_parallel_section_reduction(){
  int sum=7;
  int known_sum;
  int i;

  
#pragma omp parallel sections private(i)
    {
#pragma omp section
      {
	for (i=1;i<400;i++){
	  sum += i;
	}
      }
#pragma omp section
      {
	for(i=400;i<700;i++)
	  sum += i;
      }
#pragma omp section
      {
	for(i=700;i<1000;i++)
	  sum += i;
      }
      
    }/* end of section reduction.*/
 
  known_sum=(999*1000)/2+7;
  return (known_sum==sum);
}



int check_parallel_section_private(){
  int sum=7;
  int sum0=0;
  int known_sum;
  int i;
#pragma omp parallel sections private(sum0,i)
  {
#pragma omp section 
    {
      sum0=0;
      for (i=1;i<400;i++)
	sum0=sum0+i;
#pragma omp critical
      {
	sum= sum+sum0;
      }                         /*end of critical */
    }    
#pragma omp section
    {
      sum0=0;
      for(i=400;i<700;i++)
	sum0=sum0+i;
#pragma omp critical
      {
	sum= sum+sum0;
      }                         /*end of critical */
    }
#pragma omp section
    {
      sum0=0;
      for(i=700;i<1000;i++)
	sum0=sum0+i;
#pragma omp critical
      {
	sum= sum+sum0;
      }                         /*end of critical */
    }               
  }        /*end of paralell sections*/
known_sum=(999*1000)/2+7;
return (known_sum==sum); 
}                              /* end of check_section_private*/

int crosscheck_parallel_section_private(){
  int sum=7;
  int sum0=0;
  int known_sum;
  int i;
#pragma omp parallel sections private(i)
  {
#pragma omp section 
    {
      sum0=0;
      for (i=1;i<400;i++)
	sum0=sum0+i;
#pragma omp critical
      {
	sum= sum+sum0;
      }                         /*end of critical */
    }    
#pragma omp section
    {
      sum0=0;
      for(i=400;i<700;i++)
	sum0=sum0+i;
#pragma omp critical
      {
	sum= sum+sum0;
      }                         /*end of critical */
    }
#pragma omp section
    {
      sum0=0;
      for(i=700;i<1000;i++)
	sum0=sum0+i;
#pragma omp critical
      {
	sum= sum+sum0;
      }                         /*end of critical */
    }               
  }        /*end of paralell sections*/
known_sum=(999*1000)/2+7;
return (known_sum==sum); 
}                              /* end of check_section_private*/

int check_parallel_section_firstprivate(){
int sum=7;
  int sum0=11;
  int known_sum;
#pragma omp parallel sections firstprivate(sum0) 
  {
#pragma omp section 
    {
#pragma omp critical
      {
	sum= sum+sum0;
      }                         /*end of critical */
    }    
#pragma omp section
    {
#pragma omp critical
      {
	sum= sum+sum0;
      }                         /*end of critical */
    }
#pragma omp section
    {
#pragma omp critical
      {
	sum= sum+sum0;
      }                         /*end of critical */
    }               
    }      /*end of parallel sections*/
known_sum=11*3+7;
return (known_sum==sum); 
}                              /* end of check_section_firstprivate*/


int crosscheck_parallel_section_firstprivate(){
int sum=7;
  int sum0=11;
  int known_sum;
#pragma omp parallel sections private(sum0) 
  {
#pragma omp section 
    {
#pragma omp critical
      {
	sum= sum+sum0;
      }                         /*end of critical */
    }    
#pragma omp section
    {
#pragma omp critical
      {
	sum= sum+sum0;
      }                         /*end of critical */
    }
#pragma omp section
    {
#pragma omp critical
      {
	sum= sum+sum0;
      }                         /*end of critical */
    }               
    }      /*end of parallel sections*/
known_sum=11*3+7;
return (known_sum==sum); 
}                              /* end of check_section_firstprivate*/



int check_parallel_section_lastprivate(){
  int sum=0;
  int sum0=0;
  int known_sum;
  int i;
  int i0=-1;
#pragma omp parallel sections  lastprivate(i0) private(i,sum0)
    {
#pragma omp section  
      {
	sum0=0;
	for (i=1;i<400;i++)
	  {
	    sum0=sum0+i;
	    i0=i;
	  }
#pragma omp critical
	{
	  sum= sum+sum0;
	}                         /*end of critical*/
      }/* end of section */
#pragma omp section 
      {
	sum0=0;
	for(i=400;i<700;i++)
	  {
	    sum0=sum0+i;                       /*end of for*/
	    i0=i;
	  }
#pragma omp critical
	{
	  sum= sum+sum0;
	}                         /*end of critical*/
      }
#pragma omp section 
      {
	sum0=0;
	for(i=700;i<1000;i++)
	  {
	    sum0=sum0+i;
      i0=i;
	  }
#pragma omp critical
	{
	  sum= sum+sum0;
	}                         /*end of critical*/
      }
    }/* end of parallel sections*/
   known_sum=(999*1000)/2;
  return ((known_sum==sum) && (i0==999) );
}

int crosscheck_parallel_section_lastprivate(){
  int sum=0;
  int sum0=0;
  int known_sum;
  int i;
  int i0=-1;
#pragma omp parallel sections  private(i0) private(i,sum0)
    {
#pragma omp section  
      {
	sum0=0;
	for (i=1;i<400;i++)
	  {
	    sum0=sum0+i;
	    i0=i;
	  }
#pragma omp critical
	{
	  sum= sum+sum0;
	}                         /*end of critical*/
      }/* end of section */
#pragma omp section 
      {
	sum0=0;
	for(i=400;i<700;i++)
	  {
	    sum0=sum0+i;                       /*end of for*/
	    i0=i;
	  }
#pragma omp critical
	{
	  sum= sum+sum0;
	}                         /*end of critical*/
      }
#pragma omp section 
      {
	sum0=0;
	for(i=700;i<1000;i++)
	  {
	    sum0=sum0+i;
      i0=i;
	  }
#pragma omp critical
	{
	  sum= sum+sum0;
	}                         /*end of critical*/
      }
    }/* end of parallel sections*/
   known_sum=(999*1000)/2;
  return ((known_sum==sum) && (i0==999) );
}
