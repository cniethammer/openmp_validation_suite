#include <stdio.h>
#include <time.h>
#include <omp.h>
#include <unistd.h>
#include <stdlib.h>


#include <time.h>

#define NUMBER_OF_THREADS 10
#define MAX_SIZE 1000
#define MAX_TIME 10
#define SLEEPTIME 1

int main(int argc, char* argv[])
{
	int threads;
	int max_size;
	/*int tids[MAX_SIZE+1];*/
	int *tids;
	int i,m,tmp;
	int * chunksizes;
	int * tids_for_chunk;
	int result=1;	
	int notout = 1;
	int maxiter=0;
	double factor=1.0;
	
	/* get the number of iterations*/
	if (argc == 1){
	    max_size=MAX_SIZE;
	} else
	{ 
	    max_size=atoi(argv[1]);
	}
	printf("# Using an iteration count of %d\n",max_size);
	tids=(int*)malloc(max_size*sizeof(int)+1);

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
   The highest iteration count that is reached by the threads is saved
   in the shared variable maxiter. Each thread waits before it continues 
   to iterate until 
   a) another thread has reached a higher iteration count
   b) the first thread has left the for loop (notout==0)
   c) a timeout occurs

*/

#pragma omp parallel shared(tids) 
	{
		int count = 0;
		int tid;
		tid = omp_get_thread_num();
		
/*#pragma omp for nowait schedule(guided,1)*/
#pragma omp for nowait schedule(runtime)
		for(i=0;i<max_size;++i)
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
	    int openwork = max_size;
	    int expected_chunk_size=max_size;
	    
	    for(i=0;i<NUMBER_OF_THREADS;i++)
		local_chunknr[i]=0;
	    
	    tids[max_size]=-1;
	    

	    /*fprintf(logFile,"# global_chunknr thread local_chunknr chunksize\n"); */
	    for(i=1;i<=max_size;++i)
	    {
		if(tmp==tids[i])
		{
		    m++;
		}
		else
		{
		    /*fprintf(logFile,"%d\t%d\t%d\t%d\n",global_chunknr,tmp,local_chunknr[tmp],m);*/
		    global_chunknr++;
		    local_chunknr[tmp]++;
		    tmp=tids[i];
		    m=1;
		}
	    }
	    chunksizes = (int*)malloc(global_chunknr * sizeof(int));
	    tids_for_chunk = (int*)malloc(global_chunknr * sizeof(int));
	    global_chunknr = 0;
	    
	    m = 1;
	    tmp=tids[0];	    
	    for(i=1;i<=max_size;++i)
	    {
		if(tmp==tids[i])
		{
		    m++;
		}
		else
		{
		    chunksizes[global_chunknr] = m;
		    tids_for_chunk[global_chunknr]=tmp;
		    global_chunknr++;
		    local_chunknr[tmp]++;
		    tmp=tids[i];
		    m=1;
		}
	    }
		printf("# global_chunknr thread_id chunksize remaining_items lin_factor expected_chunk)\n");
	    for(i=0;i<global_chunknr;i++)
	    {
	    	if(expected_chunk_size > 1) expected_chunk_size = openwork / threads;
		result = result && (abs(chunksizes[i]-expected_chunk_size) < 2);
	    	openwork -= chunksizes[i];
		printf("%d %d %d %d %f %d\n",i,tids_for_chunk[i],chunksizes[i],openwork,(double)chunksizes[i]/expected_chunk_size,(int)(factor*expected_chunk_size+0.5));
		factor=(double)chunksizes[i]/expected_chunk_size;
	    }
	    if(result)
	    	printf("Alles OK\n");
	    else
		printf("FEHLER!\n");	
	}
	free(tids);
	return result;
}

