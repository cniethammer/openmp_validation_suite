#include <stdio.h>
#include <omp.h>
#include <unistd.h>
#include <stdlib.h>

#include "omp_testsuite.h"


#define NUMBER_OF_THREADS 10
#define CFSMAX_SIZE 1000
#define CFDMAX_SIZE 1000000
#define MAX_TIME 10
#define SLEEPTIME 1


int check_for_schedule(FILE * logFile)
{
	int result;
	fprintf(logFile,"+ Checking static case:\n");
	result = check_for_schedule_static(logFile);
	fprintf(logFile,"+ Checking dynamic case:\n");
	result &= check_for_schedule_dynamic(logFile),
	fprintf(logFile,"+ Checking guided case:\n");
	result &= check_for_schedule_guided(logFile);
	return result;
}

int crosscheck_for_schedule(FILE * logFile)
{
	int result;
	fprintf(logFile,"+ Checking static case:\n");
	result = crosscheck_for_schedule_static(logFile);
	fprintf(logFile,"+ Checking dynamic case:\n");
	result &= crosscheck_for_schedule_dynamic(logFile),
	fprintf(logFile,"+ Checking guided case:\n");
	result &= crosscheck_for_schedule_guided(logFile);
	return result;
}

/* a subroutine for finding num of chunks,thread number,and the c
hunk-size*/



int check_for_schedule_static(FILE * logFile)
{
	const int chunk_size = 7;
	int threads;
	int tids[CFSMAX_SIZE];
	int i,lasttid;
	int maxiter;
	int notout = 1;
	int counter = 0;
	int tmp_count=1;
	int lastthreadsstarttid = -1;
	int result = 0;

#pragma omp parallel shared(tids,counter)
	{ /* begin of parallel*/
#pragma omp single
		{
			threads = omp_get_num_threads();
		}
	} /* end of parallel */
	
	if(threads < 2)
	{
		printf("This test only works with at least two threads");
		fprintf(logFile,"This test only works with at least two threads");
		return 0;
	}
	else 
	{
		fprintf(logFile,"Using an internal count of %d\nUsing a specified chunksize of %d\n",CFSMAX_SIZE,chunk_size);
		tids[CFSMAX_SIZE-1] = -1; /* setting endflag */
#pragma omp parallel shared(tids)
		{ /* begin of parallel */
			int count = 0;
			int tid;
			tid = omp_get_thread_num();

#pragma omp for nowait schedule(static,chunk_size)
			for(i=0;i<CFSMAX_SIZE-1;++i)
			{
				count=0;
#pragma omp flush(maxiter)
				if(i > maxiter)
				{
#pragma omp critical
					{
						maxiter=i;
					} 
				}
				/*printf("thread %d sleeping",tid);*/
				while(notout && (count < MAX_TIME) && (maxiter==i))
				{
#pragma omp flush(maxiter,notout)
					sleep(SLEEPTIME);
					count+=SLEEPTIME;
				}
				/*printf("thread %d awake",tid);*/
				tids[i] = tid;
			}

			notout = 0;
#pragma omp flush(maxiter,notout)
		} /* end of parallel */



		lasttid = tids[0];
		tmp_count = 0; 

		for(i=1;i<CFSMAX_SIZE;++i){
			if(tids[i] == lasttid)
			{
				tmp_count++;
			}
			if(tids[i] == lasttid + 1 || tids[i] == 0)
			{
				if(tmp_count < chunk_size && lastthreadsstarttid < 0)
				{
					lastthreadsstarttid = tids[i-1];
				}
				if(tmp_count > chunk_size)
				{
					result++;
					fprintf(logFile,"Thread got %d chunks instead of %d",tmp_count,chunk_size);
					tmp_count = 1;
					lasttid = tids[i];
				}
				if(lastthreadsstarttid == tids[i])
				{
					result++;
					fprintf(logFile,"Error: Thread got chunk after he got his endchunk");
				}
			}
			if(tids[i] >= threads)
			{
				fprintf(logFile,"Found thread with a threadnumber greater than the number of existing threads");
			}
			else
			{
				fprintf(logFile,"The next chunk was got by thread number %d instead of thread number %d",tids[i],(lasttid==threads)?lasttid+1:0);
				result++;
			}
		}
		/*printf("Alles OK beim Test von schedule(static)\n");*/
		return result;
	}
}

int crosscheck_for_schedule_static(FILE * logFile)
{
	const int chunk_size = 7;
	int threads;
	int tids[CFSMAX_SIZE];
	int i,lasttid;
	int maxiter;
	int notout = 1;
	int counter = 0;
	int tmp_count=1;
	int lastthreadsstarttid = -1;
	int result = 0;

#pragma omp parallel shared(tids,counter)
	{ /* begin of parallel*/
#pragma omp single
		{
			threads = omp_get_num_threads();
		}
	} /* end of parallel */
	
	if(threads < 2)
	{
		printf("This test only works with at least two threads");
		fprintf(logFile,"This test only works with at least two threads");
		return 0;
	}
	else 
	{
		fprintf(logFile,"Using an internal count of %d\nUsing a specified chunksize of %d\n",CFSMAX_SIZE,chunk_size);
		tids[CFSMAX_SIZE-1] = -1; /* setting endflag */
#pragma omp parallel shared(tids)
		{ /* begin of parallel */
			int count = 0;
			int tid;
			tid = omp_get_thread_num();

#pragma omp for nowait
			for(i=0;i<CFSMAX_SIZE-1;++i)
			{
				count=0;
#pragma omp flush(maxiter)
				if(i > maxiter)
				{
#pragma omp critical
					{
						maxiter=i;
					} 
				}
				/*printf("thread %d sleeping",tid);*/
				while(notout && (count < MAX_TIME) && (maxiter==i))
				{
#pragma omp flush(maxiter,notout)
					sleep(SLEEPTIME);
					count+=SLEEPTIME;
				}
				/*printf("thread %d awake",tid);*/
				tids[i] = tid;
			}

			notout = 0;
#pragma omp flush(maxiter,notout)
		} /* end of parallel */


		lasttid = tids[0];
		tmp_count = 0; 

		for(i=1;i<CFSMAX_SIZE;++i){
			if(tids[i] == lasttid)
			{
				tmp_count++;
			}
			if(tids[i] == lasttid + 1 || tids[i] == 0)
			{
				if(tmp_count < chunk_size && lastthreadsstarttid < 0)
				{
					lastthreadsstarttid = tids[i-1];
				}
				if(tmp_count > chunk_size)
				{
					result++;
					/*fprintf(logFile,"Thread got %d chunks instead of %d",tmp_count,chunk_size);*/
					tmp_count = 1;
					lasttid = tids[i];
				}
				if(lastthreadsstarttid == tids[i])
				{
					result++;
					/*fprintf(logFile,"Error: Thread got chunk after he got his endchunk");*/
				}
			}
			if(tids[i] >= threads)
			{
				/*fprintf(logFile,"Found thread with a threadnumber greater than the number of existing threads");*/
			}
			else
			{
				/*fprintf(logFile,"The next chunk was got by thread number %d instead of thread number %d",tids[i],(lasttid==threads)?lasttid+1:0);*/
				result++;
			}
		}
		return result;
	}
}


int check_for_schedule_dynamic(FILE * logFile)
{
    const int chunk_size = 10;
    int tid;
    int tids[CFDMAX_SIZE];
    int count = 0;
    int tmp_count = 0;
    int *tmp;
    int i;
    int result = 1;

#pragma omp parallel private(tid) shared(tids,count)
{ /* begin of parallel*/

    tid = omp_get_thread_num();
#pragma omp for schedule(dynamic,chunk_size)

	for(i=0;i<CFDMAX_SIZE;++i)
    {
        tids[i] = tid;
    }

} /* end of parallel */

    for(i=0;i<CFDMAX_SIZE-1;++i){
        if(tids[i]!=tids[i+1])
        {
            count++;
        }
    }
    
	tmp = (int*) malloc(sizeof(int)*(count+1));
	tmp[0]=1;
    
	for(i=0;i<CFDMAX_SIZE-1;++i){
		if(tmp_count>count)
        {
            printf("--------------------\nTestinternal Error: List too small!!!\n--------------------\n"); /* Error handling */
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
    if((tmp[0]!= CFDMAX_SIZE) && (result > 1))
    {
		fprintf(logFile,"Seems to work. (Treads got %d times chunks \"twice\" by a total of %d chunks)\n",result,CFDMAX_SIZE/chunk_size); 
		return 1;
    }
    else
    {
		fprintf(logFile,"Test negativ.\n");
		return 0;
    }
}


int crosscheck_for_schedule_dynamic(FILE * logFile)
{
    const int chunk_size = 10;
    int tid;
    int tids[CFDMAX_SIZE];
    int count = 0;
    int tmp_count = 0;
    int *tmp;
    int i;
    int result = 1;

#pragma omp parallel private(tid) shared(tids,count)
{ /* begin of parallel*/

    tid = omp_get_thread_num();
#pragma omp for

	for(i=0;i<CFDMAX_SIZE;++i)
    {
        tids[i] = tid;
    }

} /* end of parallel */

    for(i=0;i<CFDMAX_SIZE-1;++i){
        if(tids[i]!=tids[i+1])
        {
            count++;
        }
    }
    
	tmp = (int*)malloc(sizeof(int)*(count+1));
	tmp[0]=1;
    
	for(i=0;i<CFDMAX_SIZE-1;++i){
		if(tmp_count>count)
        {
            printf("--------------------\nTestinternal Error: List too small!!!\n--------------------\n"); /* Error handling */
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
    if((tmp[0]!= CFDMAX_SIZE) && (result > 1))
    {
		/*fprintf(logFile,"Seems to work. (Treads got %d times chunks \"twice\" by a total of %d chunks)\n",result,CFDMAX_SIZE/chunk_size); */
		return 1;
    }
    else
    {
		/*fprintf(logFile,"Test negativ.\n");*/
		return 0;
    }
}

int check_for_schedule_guided(FILE * logFile)
{
	int threads;
	int tids[CFSMAX_SIZE+1];
	int i,m,tmp;
	int * chunksizes;
	int result=1;	
	int notout = 1;
	int maxiter=0;
	
#pragma omp parallel
	{
#pragma omp single
	    {
		threads = omp_get_num_threads();
	    }
	}

	if(threads < 2)
	{
		printf("This test only works with at least two threads .\n");
		return 0;
	}

/* Now the real parallel work:  

   Each thread will start immediately with the first chunk.

*/

#pragma omp parallel shared(tids) 
	{
		int count = 0.;
		int tid;
		tid = omp_get_thread_num();
		

#pragma omp for nowait schedule(guided,1)
		for(i=0;i<CFSMAX_SIZE;++i)
		{
			/*printf(" notout=%d, count= %d\n",notout,count);*/
			count=0;
			#pragma omp flush(maxiter)
			if(i>maxiter){
			    #pragma omp critical
			    {
				maxiter=i;
			    }
			}

			/* if it is not our turn we wait 
                            a) until another thread executed an iteration 
                               with a higher iteration count
                            b) we are at the end of the loop (first thread finished                           and set notout=0 OR
                            c) timeout arrived */ 

			while(notout && (count < MAX_TIME) && (maxiter==i))
			{
			/*printf("Thread Nr. %d sleeping\n",tid);*/
#pragma omp flush(maxiter,notout)
				sleep(SLEEPTIME);
				count+=SLEEPTIME;
			}
			/*printf("Thread Nr. %d working once\n",tid);*/
			tids[i]=tid;
		} /*end omp for*/
		
		notout = 0;
#pragma omp flush(notout)
	}/* end omp parallel*/

	m=1;
	tmp=tids[0];
	
	{
	    int global_chunknr=0;
	    int local_chunknr[NUMBER_OF_THREADS];
	    int openwork = CFSMAX_SIZE;
	    int expected_chunk_size;
	    
	    for(i=0;i<NUMBER_OF_THREADS;i++)
		local_chunknr[i]=0;
	    
	    tids[CFSMAX_SIZE]=-1;
	    

	    /*fprintf(logFile,"# global_chunknr thread local_chunknr chunksize\n"); */
	    for(i=1;i<=CFSMAX_SIZE;++i)
	    {
		if(tmp==tids[i])
		{
		    m++;
		}
		else
		{
		    fprintf(logFile,"%d\t%d\t%d\t%d\n",global_chunknr,tmp,local_chunknr[tmp],m);
		    global_chunknr++;
		    local_chunknr[tmp]++;
		    tmp=tids[i];
		    m=1;
		}
	    }
	    chunksizes = (int*)malloc(global_chunknr * sizeof(int));
	    global_chunknr = 0;
	    
	    m = 1;
	    tmp=tids[0];	    
	    for(i=1;i<=CFSMAX_SIZE;++i)
	    {
		if(tmp==tids[i])
		{
		    m++;
		}
		else
		{
		    chunksizes[global_chunknr] = m;
		    global_chunknr++;
		    local_chunknr[tmp]++;
		    tmp=tids[i];
		    m=1;
		}
	    }

	    for(i=0;i<global_chunknr;i++)
	    {
	    	if(expected_chunk_size>2) expected_chunk_size = openwork / threads;
		result = result && (abs(chunksizes[i]-expected_chunk_size) < 2);
	    	openwork -= chunksizes[i];
	    }	
	}
	
	return result;
}

int crosscheck_for_schedule_guided(FILE * logFile)
{
	int threads;
	int tids[CFSMAX_SIZE+1];
	int i,m,tmp;
	int * chunksizes;
	int result=1;	
	int notout = 1;
	int maxiter=0;
	
#pragma omp parallel
	{
#pragma omp single
	    {
		threads = omp_get_num_threads();
	    }
	}

	if(threads < 2)
	{
		printf("This test only works with at least two threads .\n");
		return 0;
	}

/* Now the real parallel work:  

   Each thread will start immediately with the first chunk.

*/

#pragma omp parallel shared(tids) 
	{
		int count = 0.;
		int tid;
		tid = omp_get_thread_num();
		

#pragma omp for nowait
		for(i=0;i<CFSMAX_SIZE;++i)
		{
			/*printf(" notout=%d, count= %d\n",notout,count);*/
			count=0;
			#pragma omp flush(maxiter)
			if(i>maxiter){
			    #pragma omp critical
			    {
				maxiter=i;
			    }
			}

			/* if it is not our turn we wait 
                            a) until another thread executed an iteration 
                               with a higher iteration count
                            b) we are at the end of the loop (first thread finished                           and set notout=0 OR
                            c) timeout arrived */ 

			while(notout && (count < MAX_TIME) && (maxiter==i))
			{
			/*printf("Thread Nr. %d sleeping\n",tid);*/
#pragma omp flush(maxiter,notout)
				sleep(SLEEPTIME);
				count+=SLEEPTIME;
			}
			/*printf("Thread Nr. %d working once\n",tid);*/
			tids[i]=tid;
		} /*end omp for*/
		
		notout = 0;
#pragma omp flush(notout)
	}/* end omp parallel*/

	m=1;
	tmp=tids[0];
	
	{
	    int global_chunknr=0;
	    int local_chunknr[NUMBER_OF_THREADS];
	    int openwork = CFSMAX_SIZE;
	    int expected_chunk_size;
	    
	    for(i=0;i<NUMBER_OF_THREADS;i++)
		local_chunknr[i]=0;
	    
	    tids[CFSMAX_SIZE]=-1;
	    

	    /*fprintf(logFile,"# global_chunknr thread local_chunknr chunksize\n"); */
	    for(i=1;i<=CFSMAX_SIZE;++i)
	    {
		if(tmp==tids[i])
		{
		    m++;
		}
		else
		{
		    fprintf(logFile,"%d\t%d\t%d\t%d\n",global_chunknr,tmp,local_chunknr[tmp],m);
		    global_chunknr++;
		    local_chunknr[tmp]++;
		    tmp=tids[i];
		    m=1;
		}
	    }
	    chunksizes = (int*)malloc(global_chunknr * sizeof(int));
	    global_chunknr = 0;
	    
	    m = 1;
	    tmp=tids[0];	    
	    for(i=1;i<=CFSMAX_SIZE;++i)
	    {
		if(tmp==tids[i])
		{
		    m++;
		}
		else
		{
		    chunksizes[global_chunknr] = m;
		    global_chunknr++;
		    local_chunknr[tmp]++;
		    tmp=tids[i];
		    m=1;
		}
	    }

	    for(i=0;i<global_chunknr;i++)
	    {
	    	if(expected_chunk_size>2) expected_chunk_size = openwork / threads;
		result = result && (abs(chunksizes[i]-expected_chunk_size) < 2);
	    	openwork -= chunksizes[i];
	    }	
	}
	
	return result;
}
