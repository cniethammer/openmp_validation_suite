#include <stdio.h>
#include <assert.h>

#include <omp.h>
#include "omp_testsuite.h"

typedef struct { 
  char* name;
  a_ptr_to_test_function pass;
  a_ptr_to_test_function fail;
} testcall;

testcall alltests[]={ 
{"num_threads",omp_check_num_threads,omp_crosscheck_num_threads},
{"omp_get_wtime",omp_check_time,omp_crosscheck_time},
{"omp_get_wticks",omp_check_ticks_time,omp_crosscheck_ticks_time},
{"single copyprivate",check_single_copyprivate,crosscheck_single_copyprivate},
{"end",0,0}
};


int main(int argc,char** argv){
  int i=0;
  int failed=0;
  int success=0;
  int crosschecked=0;
  int N=5;
  int j=0;
  int result=1;
  int crossfailed=0;
  while(alltests[i].pass){
    crossfailed=0;
    result=1;
    for(j=0;j<N;j++){
      /*      printf("%s ...",alltests[i].name);*/
      if(alltests[i].pass()){
	/*	printf(" passed");*/
      } else {
	/*	printf(" failed");*/
	result=0;
      }
    
      if(!alltests[i].fail()){
	/*printf(" and cross-checked\n");*/
	crossfailed++;
      } else {
	/*printf("\n");*/
      }
    }
    if(result==0){
      failed++;
    } 
    else {
      success++;
    }
    if(crossfailed>0){
      crosschecked++;
    }
    if(result){
      printf("%s ... verified with %5.2f%% certainty\n",alltests[i].name,100.0*crossfailed/N);
    }
    else {
      printf("%s ... FAILED\n",alltests[i].name);
    }


    i++;
  }
  printf("\n\n Performed a total of %d tests, %d failed and %d successful with %d cross checked\n",i,failed,success,crosschecked);
return failed;
}
