
#include <stdio.h>
#include <assert.h>

#include <omp.h>
#include "omp_testsuite.h"


int main(int argc,char** argv){

  printf(" Has _OPENMP macro ...");
  if (check_has_openmp() ){
    printf(" passed\n");
  } else {
    printf(" failed\n");
  }

  printf(" omp_get_num_threads ...");
  if (check_omp_get_num_threads() ){
    printf(" passed\n");
  } else {
    printf(" failed\n");
  }

  printf(" omp_in_parallel ...");
  if (check_omp_in_parallel() ){
    printf(" passed\n");
  } else {
    printf(" failed\n");
  }
  

 
 


  printf(" omp for reduction ...");
  if (check_section_reduction() ){
    printf(" passed\n");
  } else {
    printf(" failed\n");
  }
  



/*printf(" omp for private ... ");
if (check_for_private())
{
  printf("passed\n");
}
else
{
  printf("failed\n");
}



printf("omp for firstprivate...");
if (check_for_firstprivate())
{
  printf("passed\n");
}
else
{printf("failed\n");}




printf("omp for lastprivate...");
if (check_for_lastprivate())
{
printf("passed\n");
}
else
{printf("failed\n");}
return 0;
}*/































































