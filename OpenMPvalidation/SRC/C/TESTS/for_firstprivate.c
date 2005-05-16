
#include <stdio.h>
#include <math.h>
#include "omp_testsuite.h"

int
check_for_firstprivate (FILE * logFile)
{
  int sum = 0;
  int sum0 = 0;
  int sum1 = 0;
  int known_sum;
  int i;
#pragma omp parallel firstprivate(sum1)
  {
    /*sum0=0; */
#pragma omp for firstprivate(sum0)
    for (i = 1; i <= LOOPCOUNT; i++)
      {
	sum0 = sum0 + i;
	sum1 = sum0;
      }				/*end of for */
#pragma omp critical
    {
      sum = sum + sum1;
    }				/*end of critical */
  }				/* end of parallel */
  known_sum = (LOOPCOUNT * (LOOPCOUNT + 1)) / 2;
  return (known_sum == sum);
}				/* end of check_for_fistprivate */

int
crosscheck_for_firstprivate (FILE * logFile)
{
  int sum = 0;
  int sum0 = 0;
  int sum1 = 0;
  int known_sum;
  int i;
#pragma omp parallel firstprivate(sum1)
  {
    /*sum0=0; */
#pragma omp for
    for (i = 1; i <= LOOPCOUNT; i++)
      {
	sum0 = sum0 + i;
	sum1 = sum0;
      }				/*end of for */
#pragma omp critical
    {
      sum = sum + sum1;
    }				/*end of critical */
  }				/* end of parallel */
  known_sum = (LOOPCOUNT * (LOOPCOUNT + 1)) / 2;
  return (known_sum == sum);
}				/* end of check_for_fistprivate */
