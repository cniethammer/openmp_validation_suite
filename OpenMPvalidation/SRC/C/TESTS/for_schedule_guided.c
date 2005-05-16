#include <stdio.h>
#include <omp.h>
#include <unistd.h>
#include <stdlib.h>

#include "omp_testsuite.h"
#include "omp_my_sleep.h"

#define NUMBER_OF_THREADS 10
#define CFSMAX_SIZE 1000
#define CFDMAX_SIZE 1000000
#define MAX_TIME 5
#define SLEEPTIME 0.5

int
check_for_schedule_guided (FILE * logFile)
{
  int threads;
  int tids[CFSMAX_SIZE + 1];
  int i, m, tmp;
  int *chunksizes;
  int result = 1;
  int notout = 1;
  int maxiter = 0;

#pragma omp parallel
  {
#pragma omp single
    {
      threads = omp_get_num_threads ();
    }
  }

  if (threads < 2)
    {
      printf ("This test only works with at least two threads .\n");
      return 0;
    }

/* Now the real parallel work:  

   Each thread will start immediately with the first chunk.

*/

#pragma omp parallel shared(tids)
  {
    int count = 0.;
    int tid;
    tid = omp_get_thread_num ();


#pragma omp for nowait schedule(guided,1)
    for (i = 0; i < CFSMAX_SIZE; ++i)
      {
	/*printf(" notout=%d, count= %d\n",notout,count); */
	count = 0;
#pragma omp flush(maxiter)
	if (i > maxiter)
	  {
#pragma omp critical
	    {
	      maxiter = i;
	    }
	  }

	/* if it is not our turn we wait 
	   a) until another thread executed an iteration 
	   with a higher iteration count
	   b) we are at the end of the loop (first thread finished                           and set notout=0 OR
	   c) timeout arrived */

	while (notout && (count < MAX_TIME) && (maxiter == i))
	  {
	    /*printf("Thread Nr. %d sleeping\n",tid); */
#pragma omp flush(maxiter,notout)
	    my_sleep (SLEEPTIME);
	    count += SLEEPTIME;
	  }
	/*printf("Thread Nr. %d working once\n",tid); */
	tids[i] = tid;
      }				/*end omp for */

    notout = 0;
#pragma omp flush(notout)
  }				/* end omp parallel */

  m = 1;
  tmp = tids[0];

  {
    int global_chunknr = 0;
    int local_chunknr[NUMBER_OF_THREADS];
    int openwork = CFSMAX_SIZE;
    int expected_chunk_size;

    for (i = 0; i < NUMBER_OF_THREADS; i++)
      local_chunknr[i] = 0;

    tids[CFSMAX_SIZE] = -1;


    /*fprintf(logFile,"# global_chunknr thread local_chunknr chunksize\n"); */
    for (i = 1; i <= CFSMAX_SIZE; ++i)
      {
	if (tmp == tids[i])
	  {
	    m++;
	  }
	else
	  {
	    fprintf (logFile, "%d\t%d\t%d\t%d\n", global_chunknr, tmp,
		     local_chunknr[tmp], m);
	    global_chunknr++;
	    local_chunknr[tmp]++;
	    tmp = tids[i];
	    m = 1;
	  }
      }
    chunksizes = (int *) malloc (global_chunknr * sizeof (int));
    global_chunknr = 0;

    m = 1;
    tmp = tids[0];
    for (i = 1; i <= CFSMAX_SIZE; ++i)
      {
	if (tmp == tids[i])
	  {
	    m++;
	  }
	else
	  {
	    chunksizes[global_chunknr] = m;
	    global_chunknr++;
	    local_chunknr[tmp]++;
	    tmp = tids[i];
	    m = 1;
	  }
      }

    for (i = 0; i < global_chunknr; i++)
      {
	if (expected_chunk_size > 2)
	  expected_chunk_size = openwork / threads;
	result = result && (abs (chunksizes[i] - expected_chunk_size) < 2);
	openwork -= chunksizes[i];
      }
  }

  return result;
}

int
crosscheck_for_schedule_guided (FILE * logFile)
{
  int threads;
  int tids[CFSMAX_SIZE + 1];
  int i, m, tmp;
  int *chunksizes;
  int result = 1;
  int notout = 1;
  int maxiter = 0;

#pragma omp parallel
  {
#pragma omp single
    {
      threads = omp_get_num_threads ();
    }
  }

  if (threads < 2)
    {
      printf ("This test only works with at least two threads .\n");
      return 0;
    }

/* Now the real parallel work:  

   Each thread will start immediately with the first chunk.

*/

#pragma omp parallel shared(tids)
  {
    int count = 0.;
    int tid;
    tid = omp_get_thread_num ();


#pragma omp for nowait
    for (i = 0; i < CFSMAX_SIZE; ++i)
      {
	/*printf(" notout=%d, count= %d\n",notout,count); */
	count = 0;
#pragma omp flush(maxiter)
	if (i > maxiter)
	  {
#pragma omp critical
	    {
	      maxiter = i;
	    }
	  }

	/* if it is not our turn we wait 
	   a) until another thread executed an iteration 
	   with a higher iteration count
	   b) we are at the end of the loop (first thread finished                           and set notout=0 OR
	   c) timeout arrived */

	while (notout && (count < MAX_TIME) && (maxiter == i))
	  {
	    /*printf("Thread Nr. %d sleeping\n",tid); */
#pragma omp flush(maxiter,notout)
	    my_sleep (SLEEPTIME);
	    count += SLEEPTIME;
	  }
	/*printf("Thread Nr. %d working once\n",tid); */
	tids[i] = tid;
      }				/*end omp for */

    notout = 0;
#pragma omp flush(notout)
  }				/* end omp parallel */

  m = 1;
  tmp = tids[0];

  {
    int global_chunknr = 0;
    int local_chunknr[NUMBER_OF_THREADS];
    int openwork = CFSMAX_SIZE;
    int expected_chunk_size;

    for (i = 0; i < NUMBER_OF_THREADS; i++)
      local_chunknr[i] = 0;

    tids[CFSMAX_SIZE] = -1;


    /*fprintf(logFile,"# global_chunknr thread local_chunknr chunksize\n"); */
    for (i = 1; i <= CFSMAX_SIZE; ++i)
      {
	if (tmp == tids[i])
	  {
	    m++;
	  }
	else
	  {
	    fprintf (logFile, "%d\t%d\t%d\t%d\n", global_chunknr, tmp,
		     local_chunknr[tmp], m);
	    global_chunknr++;
	    local_chunknr[tmp]++;
	    tmp = tids[i];
	    m = 1;
	  }
      }
    chunksizes = (int *) malloc (global_chunknr * sizeof (int));
    global_chunknr = 0;

    m = 1;
    tmp = tids[0];
    for (i = 1; i <= CFSMAX_SIZE; ++i)
      {
	if (tmp == tids[i])
	  {
	    m++;
	  }
	else
	  {
	    chunksizes[global_chunknr] = m;
	    global_chunknr++;
	    local_chunknr[tmp]++;
	    tmp = tids[i];
	    m = 1;
	  }
      }

    for (i = 0; i < global_chunknr; i++)
      {
	if (expected_chunk_size > 2)
	  expected_chunk_size = openwork / threads;
	result = result && (abs (chunksizes[i] - expected_chunk_size) < 2);
	openwork -= chunksizes[i];
      }
  }

  return result;
}
