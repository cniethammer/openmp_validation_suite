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
check_for_schedule_static (FILE * logFile)
{
  const int chunk_size = 7;
  int threads;
  int tids[CFSMAX_SIZE];
  int i, lasttid;
  int maxiter;
  int notout = 1;
  int counter = 0;
  int tmp_count = 1;
  int lastthreadsstarttid = -1;
  int result = 0;

#pragma omp parallel shared(tids,counter)
  {				/* begin of parallel */
#pragma omp single
    {
      threads = omp_get_num_threads ();
    }
  }				/* end of parallel */

  if (threads < 2)
    {
      printf ("This test only works with at least two threads");
      fprintf (logFile, "This test only works with at least two threads");
      return 0;
    }
  else
    {
      fprintf (logFile,
	       "Using an internal count of %d\nUsing a specified chunksize of %d\n",
	       CFSMAX_SIZE, chunk_size);
      tids[CFSMAX_SIZE - 1] = -1;	/* setting endflag */
#pragma omp parallel shared(tids)
      {				/* begin of parallel */
	int count = 0;
	int tid;
	tid = omp_get_thread_num ();

#pragma omp for nowait schedule(static,chunk_size)
	for (i = 0; i < CFSMAX_SIZE - 1; ++i)
	  {
	    count = 0;
#pragma omp flush(maxiter)
	    if (i > maxiter)
	      {
#pragma omp critical
		{
		  maxiter = i;
		}
	      }
	    /*printf("thread %d sleeping",tid); */
	    while (notout && (count < MAX_TIME) && (maxiter == i))
	      {
#pragma omp flush(maxiter,notout)
		my_sleep (SLEEPTIME);
		count += SLEEPTIME;
	      }
	    /*printf("thread %d awake",tid); */
	    tids[i] = tid;
	  }

	notout = 0;
#pragma omp flush(maxiter,notout)
      }				/* end of parallel */



      lasttid = tids[0];
      tmp_count = 0;

      for (i = 1; i < CFSMAX_SIZE; ++i)
	{
	  if (tids[i] == lasttid)
	    {
	      tmp_count++;
	    }
	  if (tids[i] == lasttid + 1 || tids[i] == 0)
	    {
	      if (tmp_count < chunk_size && lastthreadsstarttid < 0)
		{
		  lastthreadsstarttid = tids[i - 1];
		}
	      if (tmp_count > chunk_size)
		{
		  result++;
		  fprintf (logFile, "Thread got %d chunks instead of %d",
			   tmp_count, chunk_size);
		  tmp_count = 1;
		  lasttid = tids[i];
		}
	      if (lastthreadsstarttid == tids[i])
		{
		  result++;
		  fprintf (logFile,
			   "Error: Thread got chunk after he got his endchunk");
		}
	    }
	  if (tids[i] >= threads)
	    {
	      fprintf (logFile,
		       "Found thread with a threadnumber greater than the number of existing threads");
	    }
	  else
	    {
	      fprintf (logFile,
		       "The next chunk was got by thread number %d instead of thread number %d",
		       tids[i], (lasttid == threads) ? lasttid + 1 : 0);
	      result++;
	    }
	}
      /*printf("Alles OK beim Test von schedule(static)\n"); */
      return result;
    }
}

int
crosscheck_for_schedule_static (FILE * logFile)
{
  const int chunk_size = 7;
  int threads;
  int tids[CFSMAX_SIZE];
  int i, lasttid;
  int maxiter;
  int notout = 1;
  int counter = 0;
  int tmp_count = 1;
  int lastthreadsstarttid = -1;
  int result = 0;

#pragma omp parallel shared(tids,counter)
  {				/* begin of parallel */
#pragma omp single
    {
      threads = omp_get_num_threads ();
    }
  }				/* end of parallel */

  if (threads < 2)
    {
      printf ("This test only works with at least two threads");
      fprintf (logFile, "This test only works with at least two threads");
      return 0;
    }
  else
    {
      fprintf (logFile,
	       "Using an internal count of %d\nUsing a specified chunksize of %d\n",
	       CFSMAX_SIZE, chunk_size);
      tids[CFSMAX_SIZE - 1] = -1;	/* setting endflag */
#pragma omp parallel shared(tids)
      {				/* begin of parallel */
	int count = 0;
	int tid;
	tid = omp_get_thread_num ();

#pragma omp for nowait
	for (i = 0; i < CFSMAX_SIZE - 1; ++i)
	  {
	    count = 0;
#pragma omp flush(maxiter)
	    if (i > maxiter)
	      {
#pragma omp critical
		{
		  maxiter = i;
		}
	      }
	    /*printf("thread %d sleeping",tid); */
	    while (notout && (count < MAX_TIME) && (maxiter == i))
	      {
#pragma omp flush(maxiter,notout)
		my_sleep (SLEEPTIME);
		count += SLEEPTIME;
	      }
	    /*printf("thread %d awake",tid); */
	    tids[i] = tid;
	  }

	notout = 0;
#pragma omp flush(maxiter,notout)
      }				/* end of parallel */


      lasttid = tids[0];
      tmp_count = 0;

      for (i = 1; i < CFSMAX_SIZE; ++i)
	{
	  if (tids[i] == lasttid)
	    {
	      tmp_count++;
	    }
	  if (tids[i] == lasttid + 1 || tids[i] == 0)
	    {
	      if (tmp_count < chunk_size && lastthreadsstarttid < 0)
		{
		  lastthreadsstarttid = tids[i - 1];
		}
	      if (tmp_count > chunk_size)
		{
		  result++;
		  /*fprintf(logFile,"Thread got %d chunks instead of %d",tmp_count,chunk_size); */
		  tmp_count = 1;
		  lasttid = tids[i];
		}
	      if (lastthreadsstarttid == tids[i])
		{
		  result++;
		  /*fprintf(logFile,"Error: Thread got chunk after he got his endchunk"); */
		}
	    }
	  if (tids[i] >= threads)
	    {
	      /*fprintf(logFile,"Found thread with a threadnumber greater than the number of existing threads"); */
	    }
	  else
	    {
	      /*fprintf(logFile,"The next chunk was got by thread number %d instead of thread number %d",tids[i],(lasttid==threads)?lasttid+1:0); */
	      result++;
	    }
	}
      return result;
    }
}
