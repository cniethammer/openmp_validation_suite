<ompts:test>
<ompts:testdescription>Test which checks the guided option of the omp for schedule directive.</ompts:testdescription>
<ompts:ompversion>2.0</ompts:ompversion>
<ompts:directive>omp for schedule(guided)</ompts:directive>
<ompts:dependences>omp flush,omp for nowait,omp critical,omp single</ompts:dependences>
<ompts:testcode>
#include <stdio.h>
#include <unistd.h>
#include <stdlib.h>

#include "omp_testsuite.h"
#include "omp_my_sleep.h"

#define NUMBER_OF_THREADS 10
#define CFSMAX_SIZE 50000
#define MAX_TIME  0.005

#ifdef SLEEPTIME
#undef SLEEPTIME
#define SLEEPTIME 0.0001
#endif

int <ompts:testcode:functionname>omp_for_schedule_guided</ompts:testcode:functionname> (FILE * logFile)
{
    <ompts:orphan:vars>
	int * tids;
	int * chunksizes;
	int notout;
	int maxiter;
    </ompts:orphan:vars>

    int threads;
    int i;
    int result;

    tids = (int *) malloc (sizeof (int) * (CFSMAX_SIZE + 1));
	maxiter = 0;
    result = 1;
    notout = 1;

/* Testing if enought threads are available for this check. */
#pragma omp parallel
	{
#pragma omp single
	  {
		threads = omp_get_num_threads ();
	  } /* end of single */
	} /* end of parallel */

	if (threads < 2) {
	  printf ("This test only works with at least two threads .\n");
	  fprintf (logFile, "This test only works with at least two threads. Available were only %d thread(s).\n", threads);
	  return (0);
	} /* end if */


    /* Now the real parallel work:  
     *
	 * Each thread will start immediately with the first chunk.
     */
#pragma omp parallel shared(tids) 
    {
	<ompts:orphan>
	    int tid;
	    int j;

	    tid = omp_get_thread_num ();

#pragma omp for nowait <ompts:check>schedule(guided,1)</ompts:check>
	    for(j = 0; j < CFSMAX_SIZE; j++)
		{
		  int count = 0;
		  /* fprintf (logFile, " notout = %d, count = %d\n", notout, count); */
#pragma omp flush(maxiter)
		  if (j > maxiter){
#pragma omp critical
			{
			  maxiter = j;
			}
		  }

		  /* if it is not our turn we wait 
			 a) until another thread executed an iteration with a higher iteration count
			 b) we are at the end of the loop (first thread finished and set notout = 0 OR
			 c) timeout arrived */ 

#pragma omp flush(maxiter)
		  while (notout && (count < MAX_TIME) && (maxiter == j))
		  {
			/* fprintf (logFile, "Thread Nr. %d going to sleep and waking up other thread\n", tid); */
            my_sleep (SLEEPTIME);
			count += SLEEPTIME;
#pragma omp flush(maxiter,notout)
		  }
		  /* fprintf (logFile, "Thread Nr. %d woke up and is working once begining with workNr. %d\n", tid,j); */
		  tids[j] = tid;
		} /* end omp for */
	</ompts:orphan>	

	notout = 0;
#pragma omp flush(notout)
    } /* end omp parallel */

/*******************************************************
 * evaluation of the values                            *
 *******************************************************/
	{
	  int determined_chunksize = 1;
	  int last_threadnr = tids[0];
	  int global_chunknr = 0;
	  int local_chunknr[NUMBER_OF_THREADS];
	  int openwork = CFSMAX_SIZE;
	  int expected_chunk_size;
	  double c = 1;

	  for (i = 0; i < NUMBER_OF_THREADS; i++)
		local_chunknr[i] = 0;

	  tids[CFSMAX_SIZE] = -1;

      /*
	   * determine the number of global chunks
	   */
	  /*fprintf(logFile,"# global_chunknr thread local_chunknr chunksize\n"); */
	  for(i = 1; i <= CFSMAX_SIZE; ++i)
	  {
		if (last_threadnr==tids[i]) { 
		  determined_chunksize++; 
		}
		else
		{
		  /* fprintf (logFile, "%d\t%d\t%d\t%d\n", global_chunknr,last_threadnr, local_chunknr[last_threadnr], m); */
		  global_chunknr++;
		  local_chunknr[last_threadnr]++;
		  last_threadnr = tids[i];
		  determined_chunksize = 1;
		}
	  }
	  /* now allocate the memory for saving the sizes of the global chunks */
	  chunksizes = (int*)malloc(global_chunknr * sizeof(int));

      /*
	   * Evaluate the sizes of the global chunks
	   */
	  global_chunknr = 0;
	  determined_chunksize = 1;
	  last_threadnr = tids[0];	    
	  for (i = 1; i <= CFSMAX_SIZE; ++i)
	  {
		/* If the threadnumber was the same as before increase the detected chunksize for this chunk
		 * otherwise set the detected chunksize again to one and save the number of the next thread in last_threadnr. 
		 */
		if (last_threadnr == tids[i]) { 
		  determined_chunksize++; 
		}
		else {
		  chunksizes[global_chunknr] = determined_chunksize;
		  global_chunknr++;
		  local_chunknr[last_threadnr]++;
		  last_threadnr = tids[i];
		  determined_chunksize = 1;
		}
	  }

#ifdef VERBOSE
	  fprintf (logFile, "found\texpected\tconstant\n");
#endif

	  /* identify the constant c for the exponential decrease of the chunksize */
	  expected_chunk_size = openwork / threads;
	  c = (double) chunksizes[0] / expected_chunk_size;
	  
	  for (i = 0; i < global_chunknr; i++)
	  {
		/* calculate the new expected chunksize */
		if (expected_chunk_size > 1) 
		  expected_chunk_size = c * openwork / threads;
		
#ifdef VERBOSE
		fprintf (logFile, "%8d\t%8d\t%lf\n", chunksizes[i], expected_chunk_size, c * chunksizes[i]/expected_chunk_size);
#endif
		
		/* check if chunksize is inside the rounding errors */
		if (abs (chunksizes[i] - expected_chunk_size) >= 2) {
		  result = 0;
#ifndef VERBOSE
		  fprintf (logFile, "Chunksize differed from expected value: %d instead of %d\n", chunksizes[i], expected_chunk_size);
		  return 0;
#endif
		} /* end if */

#ifndef VERBOSE
		if (expected_chunk_size - chunksizes[i] < 0 )
		  fprintf (logFile, "Chunksize did not decrease: %d instead of %d\n", chunksizes[i],expected_chunk_size);
#endif

		/* calculating the remaining ammount of work */
		openwork -= chunksizes[i];
	  }	
	}
    return result;
}
</ompts:testcode>
</ompts:test>

