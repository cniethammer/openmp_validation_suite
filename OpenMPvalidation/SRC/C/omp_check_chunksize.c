#include <stdio.h>
#include <time.h>
#include <omp.h>

#include <time.h>

#define NUMBER_OF_THREADS 5
#define MAX_SIZE 500
#define MAX_TIME 10000000
#define SLEEPTIME 0.001

int main()
{
	int tid,nexttid,threads;
	static const int chunk_size = 10;
	int tids[MAX_SIZE + chunk_size];
	int i,m,tmp;
	double count = 0.; 
	int got[20];
	int notout = 1;
	const int chunksize = 10;
	
	for(i=0;i<NUMBER_OF_THREADS;++i)
	{
		got[i]=1;
	}

	got[0]=0;
#pragma omp parallel
	{
threads = omp_get_num_threads();
	}	

	if(threads < 2)
	{
		printf("Cannot create enougth threads for this test.\n");
		return 0;
	}
#pragma omp parallel shared(tids) private (tid,nexttid)
	{
		double count = 0.;
		tid = omp_get_thread_num();
		nexttid = (tid==0)? omp_get_num_threads()-1:tid-1;
		
#pragma omp for nowait schedule(guided,1)
		for(i=0;i<MAX_SIZE;++i)
		{
			got[tid]=1;
#pragma omp flush(got)
			/*printf("Thread Nr. %d working once\n",tid);*/
			tids[i]=tid;
			/*printf("%d Thread Nr. %d starting Thread Nr. %d\n",i,tid,nexttid);*/
			got[nexttid]=0;
#pragma omp flush(got)
			while(notout && count < MAX_TIME && got[tid])
			{
#pragma omp flush(got)
				sleep(SLEEPTIME);
				count+=SLEEPTIME;
			}
			/*printf("Thread Nr. %d awake again\n",tid);*/
		}
		notout = 0;
#pragma omp for schedule(dynamic,1)
		for(m=0;m<NUMBER_OF_THREADS;++m)
		{
			got[m]=0;
		}
	}
	m=1;
	tmp=tids[0];
	
	for(i=1;i<MAX_SIZE;++i)
	{
		if(tmp==tids[i])
		{
			m++;
		}
		else
		{
			tmp=tids[i];
			printf("%d\n",m);
			m=1;
		}
	}
	return 0;
}

