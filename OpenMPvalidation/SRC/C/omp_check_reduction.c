#include <stdio.h>
#include <math.h>
#include "omp_testsuite.h"


int check_parallel_for_reduction(){
	int sum=0;
	int known_sum;
	double dsum=0;
	double dknown_sum;
	double dt=0.5;				/* base of geometric row for + and - test*/
#define DOUBLE_DIGITS 20		/* dt^DOUBLE_DIGITS */
	int diff;
	double ddiff;
	int product=1;
	int known_product;
#define MAX_FACTOR 10
#define KNOWN_PRODUCT 3628800	/* 10! */
	int logic_and=1;
	int logic_or=0;
	int logics[LOOPCOUNT];
	int i;
	double dpt,dtmp;
	int result=0;

	/*  int my_islarger;*/
	/*int is_larger=1;*/
	dt = 1./3.;
	known_sum = (LOOPCOUNT*(LOOPCOUNT+1))/2;
#pragma omp parallel for schedule(dynamic,1) reduction(+:sum)
	for (i=1;i<=LOOPCOUNT;i++)
	{
		sum=sum+i;
	}

	if(known_sum==sum) ++result;
	else printf("\nError in Sum with integers\n"); 

	diff = (LOOPCOUNT*(LOOPCOUNT+1))/2;
#pragma omp parallel for schedule(dynamic,1) reduction(-:diff)
	for (i=1;i<=LOOPCOUNT;++i)
	{
		diff=diff-i;
	}

	if(diff == 0) result++;
	else printf("\nError in Difference: Result was %d instead of 0.\n",diff);

	/* Tests for doubles not working properly yet
	   dsum=0;
	   dpt=1;
	   dtmp=1;
	   for (i=0;i<DOUBLE_DIGITS;++i)
	   {
	   dpt*=dt;
	   }
	   dknown_sum = (1-dpt)/(1-dt);
#pragma omp parallel for schedule(dynamic,1) reduction(+:dsum)
for (i=0;i<DOUBLE_DIGITS;++i)
{
dsum += dtmp;
dtmp*=dt;
}*/
	/*printf("SUM OF DOUBLES: %f, %f",dsum,dknown_sum);*/
	/*if(dsum==dknown_sum) printf("Alles OK\n"); */
	/*else printf("Nicht gut!\n");*/
	/*	if(dsum==dknown_sum) result++; 
		else printf("\nErroro in sum with doubles: Calculated: %f Expected: %f (Difference: %E)\n",dsum,dknown_sum, dsum-dknown_sum);	

		dpt=1;
		dtmp=1;
		for (i=0;i<DOUBLE_DIGITS;++i)
		{
		dpt*=dt;
		}
		ddiff = (1-dpt)/(1-dt);
#pragma omp parallel for schedule(dynamic,1) reduction(-:diff)
for (i=0;i<DOUBLE_DIGITS;++i)
{
ddiff -= dtmp;
dtmp*=dt;
}
if(ddiff == 0) result++;
else printf("\nError in Difference with doubles: Difference %E\n",ddiff);
*/
#pragma omp parallel for schedule(dynamic,1) reduction(*:product)  
	for(i=1;i<=MAX_FACTOR;i++)
{
	product *= i;
}

known_product = KNOWN_PRODUCT;
if(known_product == product) result++;
else printf("\nError in Product: Known Product: %d\tcalculated Product: %d\n\n",known_product,product);

for(i=0;i<LOOPCOUNT;i++)
{
	logics[i]=1;
}

#pragma omp parallel for schedule(dynamic,1) reduction(&&:logic_and)  
for(i=0;i<LOOPCOUNT;++i)
{
	logic_and = (logic_and && logics[i]);
}
if(logic_and) result++;
else printf("Error in AND part 1\n");

logic_and = 1;
logics[LOOPCOUNT/2]=0;

#pragma omp parallel for schedule(dynamic,1) reduction(&&:logic_and)
for(i=0;i<LOOPCOUNT;++i)
{
	logic_and = logic_and && logics[i];
}
if(!logic_and)result++;
else printf("Error in AND part 2");

for(i=0;i<LOOPCOUNT;i++)
{
	logics[i]=0;
}

#pragma omp parallel for schedule(dynamic,1) reduction(||:logic_or)  
for(i=0;i<LOOPCOUNT;++i)
{
	logic_or = logic_or || logics[i];
}
if(!logic_or)result++;
else printf("Error in OR part 1");
logic_or = 0;
logics[LOOPCOUNT/2]=1;

#pragma omp parallel for schedule(dynamic,1) reduction(||:logic_or)
for(i=0;i<LOOPCOUNT;++i)
{
	logic_or = logic_or || logics[i];
}
if(logic_or)result++;
else printf("Error in OR part 2");

/*printf("\nResult:%d\n",result);*/
return (result==7);
}

int crosscheck_parallel_for_reduction(){
	int sum=0;
	double dsum=0;
	int product=1;
	int diff;
	double ddiff;
	double dknown_sum;
#define MAX_FACTOR 10
#define KNOWN_PRODUCT 3628800
	int result=0;
	int known_sum;
	int known_product;
	int logic_and=1;
	int logic_or=0;
	int logics[LOOPCOUNT];
	int i;
	/*  int my_islarger;*/
	/*int is_larger=1;*/
	double dpt,dtmp;
	double dt=0.5;
#define DOUBLE_DIGITS 20 /* dt^DOUBLE_DIGITS */

#pragma omp parallel for schedule(dynamic,1)
	for (i=1;i<=LOOPCOUNT;i++)
	{
		sum=sum+i;
	}

	known_sum=(LOOPCOUNT*(LOOPCOUNT+1))/2;
	if(known_sum==sum) ++result;

	diff = (LOOPCOUNT*(LOOPCOUNT+1))/2;
#pragma omp parallel for schedule(dynamic,1) 
	for (i=1;i<=LOOPCOUNT;++i)
	{
		diff=diff-i;
	}

	if(diff == 0) result++;
	/*else printf("\nError in Difference: Result was %d instead of 0.\n",diff);*/

	/* Tests for doubles not working properly yet
	   dsum=0;
	   dpt=1;
	   dtmp=1;
	   for (i=0;i<DOUBLE_DIGITS;++i)
	   {
	   dpt*=dt;
	   }
	   dknown_sum = (1-dpt)/(1-dt);
#pragma omp parallel for schedule(dynamic,1)
for (i=0;i<DOUBLE_DIGITS;++i)
{
dsum += dtmp;
dtmp*=dt;
}
	/*printf("SUM OF DOUBLES: %f, %f",dsum,dknown_sum);*/
	/*if(dsum==dknown_sum) printf("Alles OK\n"); */
	/*else printf("Nicht gut!\n");*/
	/*	if(dsum==dknown_sum) result++; */
	/*else printf("\nErroro in sum with doubles\n");	*/
	/*
	   dpt=1;
	   dtmp=1;
	   for (i=0;i<DOUBLE_DIGITS;++i)
	   {
	   dpt*=dt;
	   }
	   ddiff = (1-dpt)/(1-dt);
#pragma omp parallel for schedule(dynamic,1)
for (i=0;i<DOUBLE_DIGITS;++i)
{
ddiff -= dtmp;
dtmp*=dt;
}
if(ddiff == 0) result++;*/
	/*else printf("\nError in Difference with doubles\n");*/

#pragma omp parallel for schedule(dynamic,1) 
	for(i=1;i<=MAX_FACTOR;i++)
{
	product *= i;
}

known_product = KNOWN_PRODUCT;
if(known_product == product) result++;
/* else printf("\nError in Product: Known Product: %d\tcalculated Product: %d\n\n",known_product,product);*/

for(i=0;i<LOOPCOUNT;i++)
{
	logics[i]=1;
}

#pragma omp parallel for schedule(dynamic,1) 
for(i=0;i<LOOPCOUNT;++i)
{
	logic_and = logic_and && logics[i];
}
if(logic_and)result++;
/*else printf("Error in AND part 1");*/

logic_and = 1;
logics[LOOPCOUNT/2]=0;

#pragma omp parallel for schedule(dynamic,1)
for(i=0;i<LOOPCOUNT;++i)
{
	logic_and = logic_and && logics[i];
}
if(!logic_and)result++;
/*else printf("Error in AND part 2");*/

for(i=0;i<LOOPCOUNT;i++)
{
	logics[i]=0;
}

#pragma omp parallel for schedule(dynamic,1) 
for(i=0;i<LOOPCOUNT;++i)
{
	logic_or = logic_or || logics[i];
}
if(!logic_or)result++;
/*else printf("Error in OR part 1");*/
logic_or = 0;
logics[LOOPCOUNT/2]=1;

#pragma omp parallel for schedule(dynamic,1)
for(i=0;i<LOOPCOUNT;++i)
{
	logic_or = logic_or || logics[i];
}
if(logic_or)result++;
/*else printf("Error in OR part 2");*/
/*printf("\nResult:%d\n",result);*/
return (result==7);
}

int check_for_reduction(){
	int sum=0;
	int sum2=0;
	int diff;
	double ddiff;
	int product=1;
	int i;
#define MAX_FACTOR 10
#define KNOWN_PRODUCT 3628800
	int result=0;
	int known_sum;
	int known_product;
	int logic_and=1;
	int logic_or=0;
	int logics[LOOPCOUNT];
	/*  int my_islarger;*/
	/*  int is_larger=1;*/

#pragma omp parallel
	{
#pragma omp for schedule(dynamic,1) reduction(+:sum)
		for (i=1;i<=LOOPCOUNT;i++)
		{
			sum=sum+i;
		}

#pragma omp for schedule(static,1) reduction(+:sum2)
		for (i=1;i<=LOOPCOUNT;i++)
		{
			sum2=sum2+i;
		}
	} /* end of parallel */
	known_sum=(LOOPCOUNT*(LOOPCOUNT+1))/2;
	if((known_sum == sum)&&(known_sum=sum2)) result++;
	/*else printf("\nError in Summation: Known sum: %d\tcalculated summs: %d - %d\n",known_sum,sum,sum2);*/

	diff = (LOOPCOUNT*(LOOPCOUNT+1))/2;
#pragma omp parallel
	{
#pragma omp for schedule(dynamic,1) reduction(-:diff) 
		for (i=1;i<=LOOPCOUNT;++i)
		{
			diff=diff-i;
		}
	}/* end of parallel */
	if(diff == 0) result++;
	/*else printf("\nError in Difference: Result was %d instead of 0.\n",diff);*/

#pragma omp parallel
	{
#pragma omp for schedule(dynamic,1) reduction(*:product)  
		for(i=1;i<=MAX_FACTOR;i++)
		{
			product *= i;
		}
	} /* end of parallel */
	known_product = KNOWN_PRODUCT;
	if(known_product == product) result++;
	/*else printf("\nError in Product: Known Product: %d\tcalculated Product: %d\n\n",known_product,product);*/

	for(i=0;i<LOOPCOUNT;i++)
	{
		logics[i]=1;
	}

#pragma omp parallel
	{
#pragma omp for schedule(dynamic,1) reduction(&&:logic_and)  
		for(i=0;i<LOOPCOUNT;++i)
		{
			logic_and = logic_and && logics[i];
		}
	} /* end of parallel */
	if(logic_and)result++;
	/*else printf("Error in AND part 1");*/

	logic_and = 1;
	logics[LOOPCOUNT/2]=0;

#pragma omp parallel
	{
#pragma omp for schedule(dynamic,1) reduction(&&:logic_and)
		for(i=0;i<LOOPCOUNT;++i)
		{
			logic_and = logic_and && logics[i];
		}
	} /*end of parallel */
	if(!logic_and)result++;
	/*else printf("Error in AND part 2");*/

	for(i=0;i<LOOPCOUNT;i++)
	{
		logics[i]=0;
	}

#pragma omp parallel
	{
#pragma omp for schedule(dynamic,1) reduction(||:logic_or)  
		for(i=0;i<LOOPCOUNT;++i)
		{
			logic_or = logic_or || logics[i];
		}
	} /* end of parallel */
	if(!logic_or)result++;
	/*else printf("Error in OR part 1");*/
	logic_or = 0;
	logics[LOOPCOUNT/2]=1;

#pragma omp parallel
	{
#pragma omp for schedule(dynamic,1) reduction(||:logic_or)
		for(i=0;i<LOOPCOUNT;++i)
		{
			logic_or = logic_or || logics[i];
		}
	} /* end of parallel */
	if(logic_or)result++;
	/*else printf("Error in OR part 2");*/
	/*printf("\nResult:%d\n",result);*/
	return (result==7);
}

int crosscheck_for_reduction(){
	int sum=0;
	int sum2=0;
	int diff;
	int product=1;
#define MAX_FACTOR 10
#define KNOWN_PRODUCT 3628800
	int result=0;
	int known_sum;
	int known_product;
	int logic_and=1;
	int logic_or=0;
	int logics[LOOPCOUNT];
	/*  int my_islarger;*/
	/*  int is_larger=1;*/
	int i;
	double dpt,dtmp;
	double dt=0.5;
#define DOUBLE_DIGITS 20 /* dt^DOUBLE_DIGITS */

#pragma omp parallel
	{
#pragma omp for schedule(dynamic,1)
		for (i=1;i<=LOOPCOUNT;i++)
		{
			sum=sum+i;
		}

#pragma omp for schedule(static,1)
		for (i=1;i<=LOOPCOUNT;i++)
		{
			sum2=sum2+i;
		}
	} /* end of parallel */
	known_sum=(LOOPCOUNT*(LOOPCOUNT+1))/2;
	if((known_sum == sum)&&(known_sum=sum2)) result++;
	/*else printf("\nError in Summation: Known sum: %d\tcalculated summs: %d - %d\n",known_sum,sum,sum2);*/

	diff = (LOOPCOUNT*(LOOPCOUNT+1))/2;
#pragma omp parallel
	{
#pragma omp for schedule(dynamic,1) 
		for (i=1;i<=LOOPCOUNT;++i)
		{
			diff=diff-i;
		}
	}/* end of parallel */
	if(diff == 0) result++;
	/*else printf("\nError in Difference: Result was %d instead of 0.\n",diff);*/

#pragma omp parallel
	{
#pragma omp for schedule(dynamic,1)  
		for(i=1;i<=MAX_FACTOR;i++)
		{
			product *= i;
		}
	} /* end of parallel */
	known_product = KNOWN_PRODUCT;
	if(known_product == product) result++;
	/*else printf("\nError in Product: Known Product: %d\tcalculated Product: %d\n\n",known_product,product);*/

	for(i=0;i<LOOPCOUNT;i++)
	{
		logics[i]=1;
	}

#pragma omp parallel
	{
#pragma omp for schedule(dynamic,1) 
		for(i=0;i<LOOPCOUNT;++i)
		{
			logic_and = logic_and && logics[i];
		}
	} /* end of parallel */
	if(logic_and)result++;
	/*else printf("Error in AND part 1");*/

	logic_and = 1;
	logics[LOOPCOUNT/2]=0;

#pragma omp parallel
	{
#pragma omp for schedule(dynamic,1)
		for(i=0;i<LOOPCOUNT;++i)
		{
			logic_and = logic_and && logics[i];
		}
	} /*end of parallel */
	if(!logic_and)result++;
	/*else printf("Error in AND part 2");*/

	for(i=0;i<LOOPCOUNT;i++)
	{
		logics[i]=0;
	}

#pragma omp parallel
	{
#pragma omp for schedule(dynamic,1)  
		for(i=0;i<LOOPCOUNT;++i)
		{
			logic_or = logic_or || logics[i];
		}
	} /* end of parallel */
	if(!logic_or)result++;
	/*else printf("Error in OR part 1");*/
	logic_or = 0;
	logics[LOOPCOUNT/2]=1;

#pragma omp parallel
	{
#pragma omp for schedule(dynamic,1)
		for(i=0;i<LOOPCOUNT;++i)
		{
			logic_or = logic_or || logics[i];
		}
	} /* end of parallel */
	if(logic_or)result++;
	/*else printf("Error in OR part 2");*/
	/*printf("\nResult:%d\n",result);*/
	return (result==7);
}

int check_section_reduction(){
	int sum=7;
	int known_sum;
	int diff;
	int product=1;
	int known_product;
	int logic_and=1;
	int logic_or=0;
	int logics[1000];
	int i;
	int result=0;

	/*  int my_islarger;*/
	/*int is_larger=1;*/
	known_sum = (999*1000)/2+7;
#pragma omp parallel
	{
#pragma omp sections private(i) reduction(+:sum)
		{
#pragma omp section
			{
				for (i=1;i<300;i++)
				{
					sum=sum+i;
				}
			}
#pragma omp section
			{
				for (i=300;i<700;i++)
				{
					sum=sum+i;
				}
			}
#pragma omp section
			{
				for (i=700;i<1000;i++)
				{
					sum=sum+i;
				}
			}
		}
	}

	if(known_sum==sum) ++result;
	else printf("\nError in Sum with integers\n"); 

	diff = (999*1000)/2;
#pragma omp parallel
	{
#pragma omp sections private(i) reduction(-:diff)
		{
#pragma omp section
			{
				for (i=1;i<300;i++)
				{
					diff=diff-i;
				}
			}
#pragma omp section
			{
				for (i=300;i<700;i++)
				{
					diff=diff-i;
				}
			}
#pragma omp section
			{
				for (i=700;i<1000;i++)
				{
					diff=diff-i;
				}
			}
		}
	}

	if(diff == 0) result++;
	else printf("\nError in Difference: Result was %d instead of 0.\n",diff);


	known_product = 3628800;
#pragma omp parallel
	{
#pragma omp sections private(i) reduction(*:product)
		{
#pragma omp section
			{	
				for(i=1;i<3;i++)
				{
					product *= i;
				}
			}
#pragma omp section
			{
				for(i=3;i<7;i++)
				{
					product *= i;
				}
			}
#pragma omp section
			{
				for(i=7;i<11;i++)
				{
					product *= i;
				}
			}
		}
	}


	if(known_product == product) result++;
	else printf("\nError in Product: Known Product: %d\tcalculated Product: %d\n\n",known_product,product);

	for(i=0;i<1000;i++)
	{
		logics[i]=1;
	}

#pragma omp parallel
	{
#pragma omp sections private(i) reduction(&&:logic_and)  
		{
#pragma omp section
			{
				for (i=1;i<300;i++)
				{
					logic_and = (logic_and && logics[i]);
				}
			}
#pragma omp section
			{
				for (i=300;i<700;i++)
				{
					logic_and = (logic_and && logics[i]);
				}
			}
#pragma omp section
			{
				for (i=700;i<1000;i++)
				{
					logic_and = (logic_and && logics[i]);
				}
			}
		}
	}

	if(logic_and) result++;
	else printf("Error in AND part 1\n");

	logic_and = 1;
	logics[501] = 0;

#pragma omp parallel
	{
#pragma omp sections private(i) reduction(&&:logic_and)  
		{
#pragma omp section
			{
				for (i=1;i<300;i++)
				{
					logic_and = (logic_and && logics[i]);
				}
			}
#pragma omp section
			{
				for (i=300;i<700;i++)
				{
					logic_and = (logic_and && logics[i]);
				}
			}
#pragma omp section
			{
				for (i=700;i<1000;i++)
				{
					logic_and = (logic_and && logics[i]);
				}
			}
		}
	}

	if(!logic_and)result++;
	else printf("Error in AND part 2");

	for(i=0;i<1000;i++)
	{
		logics[i]=0;
	}

#pragma omp parallel 
	{
#pragma omp sections private(i) reduction(||:logic_or)
		{
#pragma omp section
			{
				for (i=1;i<300;i++)
				{
					logic_or = (logic_or && logics[i]);
				}
			}
#pragma omp section
			{
				for (i=300;i<700;i++)
				{
					logic_or = (logic_or && logics[i]);
				}
			}
#pragma omp section
			{
				for (i=700;i<1000;i++)
				{
					logic_or = (logic_or && logics[i]);
				}
			}
		}
	}
			
	if(!logic_or) result++;
	else printf("\nError in OR part 1\n");
	
	logic_or = 0;
	logics[501]=1;

#pragma omp parallel 
	{
#pragma omp sections private(i) reduction(||:logic_or)
		{
#pragma omp section
			{
				for (i=1;i<300;i++)
				{
					logic_or = (logic_or || logics[i]);
				}
			}
#pragma omp section
			{
				for (i=300;i<700;i++)
				{
					logic_or = (logic_or || logics[i]);
				}
			}
#pragma omp section
			{
				for (i=700;i<1000;i++)
				{
					logic_or = (logic_or || logics[i]);
				}
			}
		}
	}

	if(logic_or) result++;
	else printf("\nError in OR part 2\n");

	/*printf("\nResult:%d\n",result);*/
	return (result==7);
}


int crosscheck_section_reduction(){
int sum=7;
	int known_sum;
	int diff;
	int product=1;
	int known_product;
	int logic_and=1;
	int logic_or=0;
	int logics[1000];
	int i;
	int result=0;

	/*  int my_islarger;*/
	/*int is_larger=1;*/
	known_sum = (999*1000)/2+7;
#pragma omp parallel
	{
#pragma omp sections private(i)
		{
#pragma omp section
			{
				for (i=1;i<300;i++)
				{
					sum=sum+i;
				}
			}
#pragma omp section
			{
				for (i=300;i<700;i++)
				{
					sum=sum+i;
				}
			}
#pragma omp section
			{
				for (i=700;i<1000;i++)
				{
					sum=sum+i;
				}
			}
		}
	}

	if(known_sum==sum) ++result;
	else printf("\nError in Sum with integers\n"); 

	diff = (999*1000)/2;
#pragma omp parallel
	{
#pragma omp sections private(i)
		{
#pragma omp section
			{
				for (i=1;i<300;i++)
				{
					diff=diff-i;
				}
			}
#pragma omp section
			{
				for (i=300;i<700;i++)
				{
					diff=diff-i;
				}
			}
#pragma omp section
			{
				for (i=700;i<1000;i++)
				{
					diff=diff-i;
				}
			}
		}
	}

	if(diff == 0) result++;
	else printf("\nError in Difference: Result was %d instead of 0.\n",diff);


	known_product = 3628800;
#pragma omp parallel
	{
#pragma omp sections private(i)
		{
#pragma omp section
			{	
				for(i=1;i<3;i++)
				{
					product *= i;
				}
			}
#pragma omp section
			{
				for(i=3;i<7;i++)
				{
					product *= i;
				}
			}
#pragma omp section
			{
				for(i=7;i<11;i++)
				{
					product *= i;
				}
			}
		}
	}


	if(known_product == product) result++;
	else printf("\nError in Product: Known Product: %d\tcalculated Product: %d\n\n",known_product,product);

	for(i=0;i<1000;i++)
	{
		logics[i]=1;
	}

#pragma omp parallel
	{
#pragma omp sections private(i) 
		{
#pragma omp section
			{
				for (i=1;i<300;i++)
				{
					logic_and = (logic_and && logics[i]);
				}
			}
#pragma omp section
			{
				for (i=300;i<700;i++)
				{
					logic_and = (logic_and && logics[i]);
				}
			}
#pragma omp section
			{
				for (i=700;i<1000;i++)
				{
					logic_and = (logic_and && logics[i]);
				}
			}
		}
	}

	if(logic_and) result++;
	else printf("Error in AND part 1\n");

	logic_and = 1;
	logics[501] = 0;

#pragma omp parallel
	{
#pragma omp sections private(i) 
		{
#pragma omp section
			{
				for (i=1;i<300;i++)
				{
					logic_and = (logic_and && logics[i]);
				}
			}
#pragma omp section
			{
				for (i=300;i<700;i++)
				{
					logic_and = (logic_and && logics[i]);
				}
			}
#pragma omp section
			{
				for (i=700;i<1000;i++)
				{
					logic_and = (logic_and && logics[i]);
				}
			}
		}
	}

	if(!logic_and)result++;
	else printf("Error in AND part 2");

	for(i=0;i<1000;i++)
	{
		logics[i]=0;
	}

#pragma omp parallel 
	{
#pragma omp sections private(i)
		{
#pragma omp section
			{
				for (i=1;i<300;i++)
				{
					logic_or = (logic_or && logics[i]);
				}
			}
#pragma omp section
			{
				for (i=300;i<700;i++)
				{
					logic_or = (logic_or && logics[i]);
				}
			}
#pragma omp section
			{
				for (i=700;i<1000;i++)
				{
					logic_or = (logic_or && logics[i]);
				}
			}
		}
	}
			
	if(!logic_or) result++;
	else printf("\nError in OR part 1\n");
	
	logic_or = 0;
	logics[501]=1;

#pragma omp parallel 
	{
#pragma omp sections private(i)
		{
#pragma omp section
			{
				for (i=1;i<300;i++)
				{
					logic_or = (logic_or || logics[i]);
				}
			}
#pragma omp section
			{
				for (i=300;i<700;i++)
				{
					logic_or = (logic_or || logics[i]);
				}
			}
#pragma omp section
			{
				for (i=700;i<1000;i++)
				{
					logic_or = (logic_or || logics[i]);
				}
			}
		}
	}

	if(logic_or) result++;
	else printf("\nError in OR part 2\n");

	/*printf("\nResult:%d\n",result);*/
	return (result==7);
}


int check_parallel_section_reduction(){
	int sum=7;
	int known_sum;
	int diff;
	int product=1;
	int known_product;
	int logic_and=1;
	int logic_or=0;
	int logics[1000];
	int i;
	int result=0;

	/*  int my_islarger;*/
	/*int is_larger=1;*/
	known_sum = (999*1000)/2+7;
#pragma omp parallel sections private(i) reduction(+:sum)
	{
#pragma omp section
		{
			for (i=1;i<300;i++)
			{
				sum=sum+i;
			}
		}
#pragma omp section
		{
			for (i=300;i<700;i++)
			{
				sum=sum+i;
			}
		}
#pragma omp section
		{
			for (i=700;i<1000;i++)
			{
				sum=sum+i;
			}
		}
	}

	if(known_sum==sum) ++result;
	else printf("\nError in Sum with integers\n"); 

	diff = (999*1000)/2;
#pragma omp parallel sections private(i) reduction(-:diff)
	{
#pragma omp section
		{
			for (i=1;i<300;i++)
			{
				diff=diff-i;
			}
		}
#pragma omp section
		{
			for (i=300;i<700;i++)
			{
				diff=diff-i;
			}
		}
#pragma omp section
		{
			for (i=700;i<1000;i++)
			{
				diff=diff-i;
			}
		}
	}


	if(diff == 0) result++;
	else printf("\nError in Difference: Result was %d instead of 0.\n",diff);


	known_product = 3628800;
#pragma omp parallel sections private(i) reduction(*:product)
	{
#pragma omp section
		{	
			for(i=1;i<3;i++)
			{
				product *= i;
			}
		}
#pragma omp section
		{
			for(i=3;i<7;i++)
			{
				product *= i;
			}
		}
#pragma omp section
		{
			for(i=7;i<11;i++)
			{
				product *= i;
			}
		}
	}


	if(known_product == product) result++;
	else printf("\nError in Product: Known Product: %d\tcalculated Product: %d\n\n",known_product,product);

	for(i=0;i<1000;i++)
	{
		logics[i]=1;
	}

#pragma omp parallel sections private(i) reduction(&&:logic_and)  
	{
#pragma omp section
		{
			for (i=1;i<300;i++)
			{
				logic_and = (logic_and && logics[i]);
			}
		}
#pragma omp section
		{
			for (i=300;i<700;i++)
			{
				logic_and = (logic_and && logics[i]);
			}
		}
#pragma omp section
		{
			for (i=700;i<1000;i++)
			{
				logic_and = (logic_and && logics[i]);
			}
		}
	}

	if(logic_and) result++;
	else printf("Error in AND part 1\n");

	logic_and = 1;
	logics[501] = 0;

#pragma omp parallel sections private(i) reduction(&&:logic_and)  
	{
#pragma omp section
		{
			for (i=1;i<300;i++)
			{
				logic_and = (logic_and && logics[i]);
			}
		}
#pragma omp section
		{
			for (i=300;i<700;i++)
			{
				logic_and = (logic_and && logics[i]);
			}
		}
#pragma omp section
		{
			for (i=700;i<1000;i++)
			{
				logic_and = (logic_and && logics[i]);
			}
		}
	}

	if(!logic_and)result++;
	else printf("Error in AND part 2");

	for(i=0;i<1000;i++)
	{
		logics[i]=0;
	}

#pragma omp parallel sections private(i) reduction(||:logic_or)
	{
#pragma omp section
		{
			for (i=1;i<300;i++)
			{
				logic_or = (logic_or && logics[i]);
			}
		}
#pragma omp section
		{
			for (i=300;i<700;i++)
			{
				logic_or = (logic_or && logics[i]);
			}
		}
#pragma omp section
		{
			for (i=700;i<1000;i++)
			{
				logic_or = (logic_or && logics[i]);
			}
		}
	}

	if(!logic_or) result++;
	else printf("\nError in OR part 1\n");

	logic_or = 0;
	logics[501]=1;

#pragma omp parallel sections private(i) reduction(||:logic_or)
	{
#pragma omp section
		{
			for (i=1;i<300;i++)
			{
				logic_or = (logic_or || logics[i]);
			}
		}
#pragma omp section
		{
			for (i=300;i<700;i++)
			{
				logic_or = (logic_or || logics[i]);
			}
		}
#pragma omp section
		{
			for (i=700;i<1000;i++)
			{
				logic_or = (logic_or || logics[i]);
			}
		}
	}

	if(logic_or) result++;
	else printf("\nError in OR part 2\n");

	/*printf("\nResult:%d\n",result);*/
	return (result==7);
}



int crosscheck_parallel_section_reduction(){
	int sum=7;
	int known_sum;
	int diff;
	int product=1;
	int known_product;
	int logic_and=1;
	int logic_or=0;
	int logics[1000];
	int i;
	int result=0;

	/*  int my_islarger;*/
	/*int is_larger=1;*/
	known_sum = (999*1000)/2+7;
#pragma omp parallel sections private(i)
	{
#pragma omp section
		{
			for (i=1;i<300;i++)
			{
				sum=sum+i;
			}
		}
#pragma omp section
		{
			for (i=300;i<700;i++)
			{
				sum=sum+i;
			}
		}
#pragma omp section
		{
			for (i=700;i<1000;i++)
			{
				sum=sum+i;
			}
		}
	}

	if(known_sum==sum) ++result;
	else printf("\nError in Sum with integers\n"); 

	diff = (999*1000)/2;
#pragma omp parallel sections private(i)
	{
#pragma omp section
		{
			for (i=1;i<300;i++)
			{
				diff=diff-i;
			}
		}
#pragma omp section
		{
			for (i=300;i<700;i++)
			{
				diff=diff-i;
			}
		}
#pragma omp section
		{
			for (i=700;i<1000;i++)
			{
				diff=diff-i;
			}
		}
	}


	if(diff == 0) result++;
	else printf("\nError in Difference: Result was %d instead of 0.\n",diff);


	known_product = 3628800;
#pragma omp parallel sections private(i)
	{
#pragma omp section
		{	
			for(i=1;i<3;i++)
			{
				product *= i;
			}
		}
#pragma omp section
		{
			for(i=3;i<7;i++)
			{
				product *= i;
			}
		}
#pragma omp section
		{
			for(i=7;i<11;i++)
			{
				product *= i;
			}
		}
	}


	if(known_product == product) result++;
	else printf("\nError in Product: Known Product: %d\tcalculated Product: %d\n\n",known_product,product);

	for(i=0;i<1000;i++)
	{
		logics[i]=1;
	}

#pragma omp parallel sections private(i)
	{
#pragma omp section
		{
			for (i=1;i<300;i++)
			{
				logic_and = (logic_and && logics[i]);
			}
		}
#pragma omp section
		{
			for (i=300;i<700;i++)
			{
				logic_and = (logic_and && logics[i]);
			}
		}
#pragma omp section
		{
			for (i=700;i<1000;i++)
			{
				logic_and = (logic_and && logics[i]);
			}
		}
	}

	if(logic_and) result++;
	else printf("Error in AND part 1\n");

	logic_and = 1;
	logics[501] = 0;

#pragma omp parallel sections private(i)
	{
#pragma omp section
		{
			for (i=1;i<300;i++)
			{
				logic_and = (logic_and && logics[i]);
			}
		}
#pragma omp section
		{
			for (i=300;i<700;i++)
			{
				logic_and = (logic_and && logics[i]);
			}
		}
#pragma omp section
		{
			for (i=700;i<1000;i++)
			{
				logic_and = (logic_and && logics[i]);
			}
		}
	}

	if(!logic_and)result++;
	else printf("Error in AND part 2");

	for(i=0;i<1000;i++)
	{
		logics[i]=0;
	}

#pragma omp parallel sections private(i)
	{
#pragma omp section
		{
			for (i=1;i<300;i++)
			{
				logic_or = (logic_or && logics[i]);
			}
		}
#pragma omp section
		{
			for (i=300;i<700;i++)
			{
				logic_or = (logic_or && logics[i]);
			}
		}
#pragma omp section
		{
			for (i=700;i<1000;i++)
			{
				logic_or = (logic_or && logics[i]);
			}
		}
	}

	if(!logic_or) result++;
	else printf("\nError in OR part 1\n");

	logic_or = 0;
	logics[501]=1;

#pragma omp parallel sections private(i)
	{
#pragma omp section
		{
			for (i=1;i<300;i++)
			{
				logic_or = (logic_or || logics[i]);
			}
		}
#pragma omp section
		{
			for (i=300;i<700;i++)
			{
				logic_or = (logic_or || logics[i]);
			}
		}
#pragma omp section
		{
			for (i=700;i<1000;i++)
			{
				logic_or = (logic_or || logics[i]);
			}
		}
	}

	if(logic_or) result++;
	else printf("\nError in OR part 2\n");

	/*printf("\nResult:%d\n",result);*/
	return (result==7);
}

