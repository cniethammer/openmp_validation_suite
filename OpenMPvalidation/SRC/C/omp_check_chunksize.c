#include <stdio.h>
#include <time.h>
#include <omp.h>
#include <unistd.h>

#include <time.h>

#define NUMBER_OF_THREADS 5
#define MAX_SIZE 8
#define MAX_TIME 10
#define SLEEPTIME 1

int main()
{
	int threads;
	int tids[MAX_SIZE+1];
	int i,m,tmp;

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
		
#pragma omp for nowait schedule(dynamic,1)
		for(i=0;i<MAX_SIZE;++i)
		{
			printf(" notout=%d, count= %d\n",notout,count);
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
			printf("Thread Nr. %d sleeping\n",tid);
#pragma omp flush(maxiter,notout)
				sleep(SLEEPTIME);
				count+=SLEEPTIME;
			}
			printf("Thread Nr. %d working once\n",tid);
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

	    for(i=0;i<NUMBER_OF_THREADS;i++)
		local_chunknr[i]=0;
	    
	    tids[MAX_SIZE]=-1;
	    printf("# global_chunknr thread local_chunknr chunksize\n"); 
	    for(i=1;i<=MAX_SIZE;++i)
	    {
		if(tmp==tids[i])
		{
		    m++;
		}
		else
		{
		    printf("%d %d %d %d\n",global_chunknr,tmp,local_chunknr[tmp],m);
		    global_chunknr++;
		    local_chunknr[tmp]++;
		    tmp=tids[i];
		    m=1;
		}
	    }
	}
	return 0;
}

