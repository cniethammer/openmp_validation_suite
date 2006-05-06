<ompts:test>
<ompts:testdescription>Test which checks the dynamic option of the omp for schedule directive.</ompts:testdescription>
<ompts:ompversion>2.0</ompts:ompversion>
<ompts:directive>omp for schedule(dynamic)</ompts:directive>
<ompts:dependences>omp flush,omp for nowait,omp critical,omp single</ompts:dependences>
<ompts:testcode>
#include <stdio.h>
#include <unistd.h>
#include <stdlib.h>

#include "omp_testsuite.h"
#include "omp_my_sleep.h"

#define NUMBER_OF_THREADS 10
#define CFDMAX_SIZE 50000


const int chunk_size = 7;

int <ompts:testcode:functionname>omp_for_schedule_dynamic</ompts:testcode:functionname> (FILE * logFile)
{
<ompts:orphan:vars>
    int *tids;
</ompts:orphan:vars>

    int i;
    int tidsArray[CFDMAX_SIZE];
    int count;
    int tmp_count = 0;
    int *tmp;
    int result = 0;

    tids = tidsArray;

#pragma omp parallel shared(tids,count)
    { /* begin of parallel*/

	{	/* begin of orphaned block */
	<ompts:orphan>
	    int j;
	    int tid;
	    tid = omp_get_thread_num ();
#pragma omp for <ompts:check>schedule(dynamic,chunk_size)</ompts:check>
	    for (j = 0; j < CFDMAX_SIZE; ++j)
	    {
		  /* One thread should take a short timeout to increase the probability of 
		   * dynamic distribution of the chunks. */
		  if (j == 1) {
			  my_sleep(SLEEPTIME);
#ifdef VERBOSE
			  fprintf(logFile, "Thread %d waited %lf seconds\n", tid, SLEEPTIME);
#endif
		  }
		  tids[j] = tid;
	    }	/* end of for */
	</ompts:orphan>
	}	/* end of orphaned block */
    }	/* end of parallel */
	
	/* determining the number of assigned chunks and allocating the necessary 
	 * memory for the evaluation */
	count = 1;
	for (i = 0; i < CFDMAX_SIZE - 1; ++i){
	  if(tids[i] != tids[i + 1])
		count++;
	}
#ifdef VERBOSE
	fprintf (logFile, "%d chunks were assigned.\n", count);
#endif
    tmp = (int*) malloc(sizeof (int) * (count));

	/* write the chunksizes in the tmp array */ 
    tmp[0] = 1;
    for (i = 0; i < CFDMAX_SIZE - 1; ++i)
	{
	  /* First du some error handling */
	  if (tmp_count >= count) {
		fprintf(logFile,"Error: List for the evaluation of the results is too small.\n");
		break;
	  }
	  /* Now check the chunks */
	  if (tids[i] != tids[i + 1]) {
		tmp_count++;
		tmp[tmp_count] = 1;
	  }
	  else 
		tmp[tmp_count]++;
	}
#ifdef VERBOSE
	fprintf(logFile, " Nr.:\tsize\n");
    for (i = 0; i < count; i++) 
	  fprintf(logFile, "%5d:\t%d\n", i + 1, tmp[i]);
#endif

	/* Evaluation of the results stored in the tmp array */
    for(i = 0; i < count ; ++i)
	{
	  if(tmp[i] != chunk_size) {
	    if (tmp[i] > chunk_size)
		  result++;
		else  {
		  if (i == count - 1)
			fprintf (logFile, "Last chunk had chunksize %d.\n", tmp[i]);
		  else {
			fprintf (logFile, "Error: Found chunk with chunksize %d (< %d) before the end.\n", tmp[i], chunk_size);
			result = 0;
			break;
		  }
		}
	  }
	}
	if((tmp[0] != CFDMAX_SIZE) && result ) {
	  fprintf (logFile, "Seems to work. (Treads got %d times chunks \"twice\" by a total of %d chunks)\n", result, CFDMAX_SIZE / chunk_size); 
	  return result; 
	}
	else 
	  return 0;
}
</ompts:testcode>
</ompts:test>
