<ompts:test>
<ompts:testdescription>Test which checks the omp for reduction directive wich all its options.</ompts:testdescription>
<ompts:ompversion>2.0</ompts:ompversion>
<ompts:directive>omp for reduction</ompts:directive>
<ompts:testcode>
#include <stdio.h>
#include <math.h>
#include "omp_testsuite.h"


int <ompts:testcode:functionname>omp_for_reduction</ompts:testcode:functionname>(FILE * logFile){
	int sum=0;
	int known_sum;
	double dsum=0;
	double dknown_sum;
	double dt=0.5;				/* base of geometric row for + and - test*/
	double rounding_error= 1.E-9;
#define DOUBLE_DIGITS 20		/* dt^DOUBLE_DIGITS */
	int diff;
	double ddiff;
	int product=1;
	int known_product;
#define MAX_FACTOR 10
#define KNOWN_PRODUCT 3628800	/* 10! */
	int logic_and=1;
	int logic_or=0;
	int bit_and=1;
	int bit_or=0;
	int exclusiv_bit_or=0;
	int logics[LOOPCOUNT];
	int i;
	double dpt;
	int result=0;

	dt = 1./3.;
	known_sum = (LOOPCOUNT*(LOOPCOUNT+1))/2;

#pragma omp parallel 
	{
#pragma omp for schedule(dynamic,1) <ompts:check>reduction(+:sum)</ompts:check><ompts:crosscheck></ompts:crosscheck>
		for (i=1;i<=LOOPCOUNT;i++)
		{
			sum=sum+i;
		}
	}

	if(known_sum!=sum)
	{
		result++;
		fprintf(logFile,"Error in sum with integers: Result was %d instead of %d.\n",sum,known_sum); 
	}

	diff = (LOOPCOUNT*(LOOPCOUNT+1))/2;
#pragma omp parallel 
	{
#pragma omp for schedule(dynamic,1) <ompts:check>reduction(-:diff)</ompts:check><ompts:crosscheck></ompts:crosscheck>
		for (i=1;i<=LOOPCOUNT;++i)
		{
			diff=diff-i;
		}
	}

	if(diff != 0)
	{
		result++;
		fprintf(logFile,"Error in difference with integers: Result was %d instead of 0.\n",diff);
	}

	/* Tests for doubles */
	dsum=0;
	dpt=1;

	for (i=0;i<DOUBLE_DIGITS;++i)
	{
		dpt*=dt;
	}
	dknown_sum = (1-dpt)/(1-dt);
#pragma omp parallel 
	{
#pragma omp for schedule(dynamic,1) <ompts:check>reduction(+:dsum)</ompts:check><ompts:crosscheck></ompts:crosscheck>
		for (i=0;i<DOUBLE_DIGITS;++i)
		{	
			dsum += pow(dt,i);
		}
	}

	if(dsum!=dknown_sum && (fabs(dsum-dknown_sum) > rounding_error))
	{
		result++; 
		fprintf(logFile,"\nError in sum with doubles: Result was %f instead of: %f (Difference: %E)\n",dsum,dknown_sum, dsum-dknown_sum);
	}

	dpt=1;

	for (i=0;i<DOUBLE_DIGITS;++i)
	{
		dpt*=dt;
	}
	ddiff = (1-dpt)/(1-dt);
#pragma omp parallel 
	{
#pragma omp for schedule(dynamic,1) <ompts:check>reduction(-:ddiff)</ompts:check><ompts:crosscheck></ompts:crosscheck>
		for (i=0;i<DOUBLE_DIGITS;++i)
		{
			ddiff -= pow(dt,i);
		}
	}
	if(fabs(ddiff) > rounding_error)
	{
		result++;
		fprintf(logFile,"Error in Difference with doubles: Result was %E instead of 0.0\n",ddiff);
	}

#pragma omp parallel 
	{
#pragma omp for schedule(dynamic,1) <ompts:check>reduction(*:product)</ompts:check><ompts:crosscheck></ompts:crosscheck>
		for(i=1;i<=MAX_FACTOR;i++)
		{
			product *= i;
		}
	}

	known_product = KNOWN_PRODUCT;
	if(known_product != product)
	{
		result++;
		fprintf(logFile,"Error in Product with integers: Result was %d instead of %d\n",product,known_product);
	}

	for(i=0;i<LOOPCOUNT;i++)
	{
		logics[i]=1;
	}

#pragma omp parallel 
	{
#pragma omp for schedule(dynamic,1) <ompts:check>reduction(&&:logic_and)</ompts:check><ompts:crosscheck></ompts:crosscheck>
		for(i=0;i<LOOPCOUNT;++i)
		{
			logic_and = (logic_and && logics[i]);
		}
	}
	if(!logic_and)
	{
		result++;
		fprintf(logFile,"Error in logic AND part 1\n");
	}

	logic_and = 1;
	logics[LOOPCOUNT/2]=0;

#pragma omp parallel 
	{
#pragma omp for schedule(dynamic,1) <ompts:check>reduction(&&:logic_and)</ompts:check><ompts:crosscheck></ompts:crosscheck>
		for(i=0;i<LOOPCOUNT;++i)
		{
			logic_and = logic_and && logics[i];
		}
	}
	if(logic_and)
	{
		result++;
		fprintf(logFile,"Error in logic AND part 2\n");
	}

	for(i=0;i<LOOPCOUNT;i++)
	{
		logics[i]=0;
	}

#pragma omp parallel 
	{
#pragma omp for schedule(dynamic,1) <ompts:check>reduction(||:logic_or)  </ompts:check><ompts:crosscheck></ompts:crosscheck>
		for(i=0;i<LOOPCOUNT;++i)
		{
			logic_or = logic_or || logics[i];
		}
	}
	if(logic_or)
	{
		result++;
		fprintf(logFile,"Error in logic OR part 1\n");
	}
	logic_or = 0;
	logics[LOOPCOUNT/2]=1;

#pragma omp parallel 
	{
#pragma omp for schedule(dynamic,1) <ompts:check>reduction(||:logic_or)</ompts:check><ompts:crosscheck></ompts:crosscheck>
		for(i=0;i<LOOPCOUNT;++i)
		{
			logic_or = logic_or || logics[i];
		}
	}
	if(!logic_or)
	{
		result++;
		fprintf(logFile,"Error in logic OR part 2\n");
	}


	for(i=0;i<LOOPCOUNT;++i)
	{
		logics[i]=1;
	}

#pragma omp parallel 
	{
#pragma omp for schedule(dynamic,1) <ompts:check>reduction(&:bit_and)  </ompts:check><ompts:crosscheck></ompts:crosscheck>
		for(i=0;i<LOOPCOUNT;++i)
		{
			bit_and = (bit_and & logics[i]);
		}
	}
	if(!bit_and)
	{
		result++;
		fprintf(logFile,"Error in BIT AND part 1\n");
	}

	bit_and = 1;
	logics[LOOPCOUNT/2]=0;

#pragma omp parallel 
	{
#pragma omp for schedule(dynamic,1) <ompts:check>reduction(&:bit_and)</ompts:check><ompts:crosscheck></ompts:crosscheck>
		for(i=0;i<LOOPCOUNT;++i)
		{
			bit_and = bit_and & logics[i];
		}
	}
	if(bit_and)
	{
		result++;
		fprintf(logFile,"Error in BIT AND part 2\n");
	}

	for(i=0;i<LOOPCOUNT;i++)
	{
		logics[i]=0;
	}

#pragma omp parallel 
	{
#pragma omp for schedule(dynamic,1) <ompts:check>reduction(|:bit_or)</ompts:check><ompts:crosscheck></ompts:crosscheck>
		for(i=0;i<LOOPCOUNT;++i)
		{
			bit_or = bit_or | logics[i];
		}
	}
	if(bit_or)
	{
		result++;
		fprintf(logFile,"Error in BIT OR part 1\n");
	}
	bit_or = 0;
	logics[LOOPCOUNT/2]=1;

#pragma omp parallel 
	{
#pragma omp for schedule(dynamic,1) <ompts:check>reduction(|:bit_or)</ompts:check><ompts:crosscheck></ompts:crosscheck>
		for(i=0;i<LOOPCOUNT;++i)
		{
			bit_or = bit_or | logics[i];
		}
	}
	if(!bit_or)
	{
		result++;
		fprintf(logFile,"Error in BIT OR part 2\n");
	}

	for(i=0;i<LOOPCOUNT;i++)
	{
		logics[i]=0;
	}

#pragma omp parallel 
	{
#pragma omp for schedule(dynamic,1) <ompts:check>reduction(^:exclusiv_bit_or)</ompts:check><ompts:crosscheck></ompts:crosscheck>
		for(i=0;i<LOOPCOUNT;++i)
		{
			exclusiv_bit_or = exclusiv_bit_or ^ logics[i];
		}
	}
	if(exclusiv_bit_or)
	{
		result++;
		fprintf(logFile,"Error in EXCLUSIV BIT OR part 1\n");
	}

	exclusiv_bit_or = 0;
	logics[LOOPCOUNT/2]=1;

#pragma omp parallel 
	{
#pragma omp for schedule(dynamic,1) <ompts:check>reduction(^:exclusiv_bit_or)</ompts:check><ompts:crosscheck></ompts:crosscheck>
		for(i=0;i<LOOPCOUNT;++i)
		{
			exclusiv_bit_or = exclusiv_bit_or ^ logics[i];
		}
	}
	if(!exclusiv_bit_or)
	{
		result++;
		fprintf(logFile,"Error in EXCLUSIV BIT OR part 2\n");
	}

	/*fprintf("\nResult:%d\n",result);*/
	return (result==0);
}
</ompts:testcode>
</ompts:test>
