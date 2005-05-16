#include <stdio.h>
#include <unistd.h>
#include <omp.h>
#include "omp_testsuite.h"
#include "omp_my_sleep.h"

int
check_omp_atomic (FILE * logFile)
{
  int i;
  int sum = 0;
  int known_sum;
#pragma omp parallel
  {
#pragma omp for
    for (i = 0; i < 1000; i++)
      {
#pragma omp atomic
	sum += i;
      }
  }
  known_sum = 999 * 1000 / 2;
  return (known_sum == sum);
}

int
crosscheck_omp_atomic (FILE * logFile)
{
  int i;
  int sum = 0;
  int known_sum;
#pragma omp parallel
  {
#pragma omp for
    for (i = 0; i < 1000; i++)
      {

	sum += i;
      }
  }
  known_sum = 999 * 1000 / 2;
  return (known_sum == sum);
}
