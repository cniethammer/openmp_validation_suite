/*! 
  \file
  \brief This file contains all checks for the parallel for construct.

  \author Matthias Mueller, $Author$

  \version $Revision$

  \date $Date$


  Currently the following clauses are tested:


  - ordered: checks that the order of execution is equivalent to the serial case
  - reduction: calculates a parallel sum and product with integers
  			   compares logical values with logical 'and' and logical 'or'
  - private:
  - firstprivate:
  - lastprivate:

  CVS Information:
  $Id$

*/

#include <math.h>
#include "omp_testsuite.h"

static int last_i=0;

/*! 
  Utility function: returns true if the passed argument is larger than 
  the argument of the last call of this function.
  */

int check_i_islarger2(int i){
	int islarger;
	islarger=(i>last_i);
	last_i=i;
	return (islarger);
}

int check_parallel_for_ordered(){
	int sum=0;
	int known_sum;
	int i;
	int is_larger=1;
	last_i=0;
#pragma omp parallel for schedule(static,1) ordered
	for (i=1;i<100;i++)
	{
#pragma omp ordered
		{
			is_larger= check_i_islarger2(i) && is_larger;
			sum=sum+i;
		}
	}
	known_sum=(99*100)/2;
	return (known_sum==sum) && is_larger;
}

int crosscheck_parallel_for_ordered(){
	int sum=0;
	int known_sum;
	int i;
	int is_larger=1;
	last_i=0;
#pragma omp parallel for schedule(static,1) 
	for (i=1;i<100;i++)
	{

		{
			is_larger= check_i_islarger2(i) && is_larger;
			sum=sum+i;
		}
	}
	known_sum=(99*100)/2;
	return (known_sum==sum) && is_larger;
}

void do_some_work2(){
	int i;
	double sum=0;
	for(i=0;i++;i<LOOPCOUNT){
		sum+=sqrt(i);
	}
}

int check_parallel_for_private(){
	int sum=0;
	/*int sum0=0;*/
	int known_sum;
	int i,i2,i3;
#pragma omp parallel for reduction(+:sum) private(i2) schedule(static,1)
	for (i=1;i<=LOOPCOUNT;i++)
	{
		i2=i;
#pragma omp flush
		do_some_work2();
#pragma omp flush
		sum=sum+i2;
	}                       /*end of for*/

	known_sum=(LOOPCOUNT*(LOOPCOUNT+1))/2;
	return (known_sum==sum);
}                                /* end of check_paralel_for_private*/

int crosscheck_parallel_for_private(){
	int sum=0;
	/*int sum0=0;*/
	int known_sum;
	int i,i2,i3;
#pragma omp parallel for reduction(+:sum)  schedule(static,1)
	for (i=1;i<=LOOPCOUNT;i++)
	{
		i2=i;
#pragma omp flush
		do_some_work2();
#pragma omp flush
		sum=sum+i2;
	}                       /*end of for*/

	known_sum=(LOOPCOUNT*(LOOPCOUNT+1))/2;
	return (known_sum==sum);
}                                /* end of check_paralel_for_private*/


int check_parallel_for_firstprivate()
{
	int sum=0;
	/*int sum0=0;*/
	int known_sum;
	int i2=3;

	int i;
#pragma omp parallel for firstprivate(i2) reduction(+:sum)
	for (i=1;i<=LOOPCOUNT;i++)
	{
		sum=sum+(i+i2);
	}                       /*end of for*/


	known_sum=(LOOPCOUNT*(LOOPCOUNT+1))/2+3*LOOPCOUNT;
	return (known_sum==sum);
}                                /* end of check_parallel_for_fistprivate*/

int crosscheck_parallel_for_firstprivate()
{
	int sum=0;
	/*int sum0=0;*/
	int known_sum;
	int i2=3;

	int i;
#pragma omp parallel for private(i2) reduction(+:sum)
	for (i=1;i<=LOOPCOUNT;i++)
	{
		sum=sum+(i+i2);
	}                       /*end of for*/


	known_sum=(LOOPCOUNT*(LOOPCOUNT+1))/2+3*999;
	return (known_sum==sum);
}                                /* end of check_parallel_for_fistprivate*/

int check_parallel_for_lastprivate(){
	int sum=0;
	/*int sum0=0;*/
	int known_sum;
	int i;
	int i0=-1;
#pragma omp parallel for reduction(+:sum) schedule(static,7) lastprivate(i0) 
	for (i=1;i<=LOOPCOUNT;i++)
	{
		sum=sum+i;
		i0=i;
	}                       /*end of for*/
	/* end of parallel*/    
	known_sum=(LOOPCOUNT*(LOOPCOUNT+1))/2;
	return ((known_sum==sum) && (i0==LOOPCOUNT) );
}                                /* end of check_parallel_for_lastprivate*/

int crosscheck_parallel_for_lastprivate(){
	int sum=0;
	/*int sum0=0;*/
	int known_sum;
	int i;
	int i0=-1;
#pragma omp parallel for reduction(+:sum) schedule(static,7) private(i0) 
	for (i=1;i<=LOOPCOUNT;i++)
	{
		sum=sum+i;
		i0=i;
	}                       /*end of for*/
	/* end of parallel*/    
	known_sum=(LOOPCOUNT*(LOOPCOUNT+1))/2;
	return ((known_sum==sum) && (i0==LOOPCOUNT) );
}                                /* end of check_parallel_for_lastprivate*/
