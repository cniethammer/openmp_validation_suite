#include "omp_testsuite.h"
#include <omp.h>
#include <stdio.h>

#define MAX_SIZE 1000000


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
      /*printf("a[%d]= %d \n",i,a[i]);*/
    }
  return 1;
}

/* a subroutine for finding num of chunks,thread number,and the c
hunk-size*/

int check_for_schedule_static()
{
    const int chunk_size = 10;
    int tid;
    int tids[MAX_SIZE];
    int count = 0;
    int tmp_count = 0;
	int i;
	int *tmp;
    int result = 0;

#pragma omp parallel private(tid) shared(tids,count)
{ /* begin of parallel*/

    tid = omp_get_thread_num();
#pragma omp for schedule(static,chunk_size)

	for(i=0;i<MAX_SIZE;++i)
    {
        tids[i] = tid;
    }

} /* end of parallel */

    for(i=0;i<MAX_SIZE-1;++i){
        if(tids[i]!=tids[i+1])
        {
            count++;
        }
    }
    
	tmp= malloc(sizeof(int)*(count+1));
	tmp[0]=1;
    
	for(i=0;i<MAX_SIZE-1;++i){
		if(tmp_count>count)
        {
            printf("--------------------\nError: List too small!!!\n--------------------\n"); /* Error handling */
            break;
        }
		if(tids[i]!=tids[i+1])
        {
            tmp_count++;
            tmp[tmp_count]=1;
        }
        else
        {
            tmp[tmp_count]++;
        }
    }

/* is dynamic statement working? */

    for(i=0;i<count;++i)
    {
		if(tmp[i]!=chunk_size)
        {
            result++;
        }
    }
    /* for (int i=0;i<count+1;++i) printf("%d\t:=\t%d\n",i+1,tmp[i]); */
    if(result == 0)
    {
		/* printf("Seems to work."); */
		return 1;
    }
    else
    {
		/* printf("Test negativ. (%d times)",result); */
		return 0;
    }
}

int check_for_schedule_dynamic()
{
    const int chunk_size = 10;
    int tid;
    int tids[MAX_SIZE];
    int count = 0;
    int tmp_count = 0;
	int *tmp;
	int i;
    int result = 1;

#pragma omp parallel private(tid) shared(tids,count)
{ /* begin of parallel*/

    tid = omp_get_thread_num();
#pragma omp for schedule(dynamic,chunk_size)

	for(int i=0;i<MAX_SIZE;++i)
    {
        tids[i] = tid;
    }

} /* end of parallel */

    for(int i=0;i<MAX_SIZE-1;++i){
        if(tids[i]!=tids[i+1])
        {
            count++;
        }
    }
    
	tmp = malloc(sizeof(int)*(count+1));
	tmp[0]=1;
    
	for(i=0;i<MAX_SIZE-1;++i){
		if(tmp_count>count)
        {
            printf("--------------------\nError: List too small!!!\n--------------------\n"); /* Error handling */
            break;
        }
		if(tids[i]!=tids[i+1])
        {
            tmp_count++;
            tmp[tmp_count]=1;
        }
        else
        {
            tmp[tmp_count]++;
        }
    }

/* is dynamic statement working? */

    for(i=0;i<count+1;++i)
    {
		if(tmp[i]!=chunk_size)
        {
            result+=((tmp[i]/chunk_size)-1);
        }
    }
    /* for (int i=0;i<count+1;++i) printf("%d\t:=\t%d\n",i+1,tmp[i]); */
    if((tmp[0]!= MAX_SIZE) && (result > 1))
    {
		/* printf("Seems to work. (Treads got %d times chunks \"twice\" by a total of %d chunks)\n",result,MAX_SIZE/chunk_size); */
		return 1;
    }
    else
    {
		/* printf("Test negativ."); */
		return 0;
    }
}



int check_for_schedule_guided()
{
    const int chunk_size = 1;
    int tid;
    int tids[MAX_SIZE];
    int count = 0;
    int tmp_count = 0;
	int *tmp;
	int i;
    int result = 0;

#pragma omp parallel private(tid) shared(tids,count)
{ /* begin of parallel*/

    tid = omp_get_thread_num();
#pragma omp for schedule(guided,chunk_size)

	for(int i=0;i<MAX_SIZE;++i)
    {
        tids[i] = tid;
    }

} /* end of parallel */

    for(int i=0;i<MAX_SIZE-1;++i){
        if(tids[i]!=tids[i+1])
        {
            count++;
        }
    }
    
	tmp = malloc(sizeof(int)*(count+1));
	tmp[0]=1;
    
	for(i=0;i<MAX_SIZE-1;++i){
		if(tmp_count>count)
        {
            printf("--------------------\nError: List too small!!!\n--------------------\n");  /* Error handling */
            break;
        }
		if(tids[i]!=tids[i+1])
        {
            tmp_count++;
            tmp[tmp_count]=1;
        }
        else
        {
            tmp[tmp_count]++;
        }
    }

/* is guided statement working? */
    for(i=0;i<count;++i)
    {
		if(tmp[i]>tmp[i+1])
        {
            result++;
        }
    }
    /* for (int i=0;i<count+1;++i) printf("%d\t:=\t%d\n",i+1,tmp[i]); */
    if(result > 0)
    {
		/* printf("Seems to work. (Chnunks got %d times smaller)\n",result); */
		return 1;
    }
    else
    {
		/* printf("Test negativ."); */
		return 0;
    }
}

