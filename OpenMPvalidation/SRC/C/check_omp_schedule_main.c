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
  
#ifndef USE_ASSURE
  printf(" omp_get_num_threads ...");
  if (check_omp_get_num_threads() ){
    printf(" passed\n");
  } else {
    printf(" failed\n");
  }
#endif

  printf("omp in schedule...");
if(check_for_schedule())
{
printf("passed\n");
}
else 
{printf("failed\n");}
return 0;
}

