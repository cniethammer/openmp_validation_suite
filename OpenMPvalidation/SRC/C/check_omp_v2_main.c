#include <stdio.h>
#include <assert.h>

#include <omp.h>
#include "omp_testsuite.h"

typedef struct { 
  char* name;
  a_ptr_to_test_function pass;
  a_ptr_to_test_function fail;
} testcall;


FILE * logFile;
const char * logFileName = "test2.log";

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
  int N=20;
  int j=0;
  int result=1;
  int crossfailed=0;
 
  
  logFile = fopen(logFileName,"a");
  
  printf("######## OpenMP Validation Suite V 0.93 ######\n");
  printf("## Repetitions: %3d                       ####\n",N);
  printf("## Loop Count : %6d                    ####\n",LOOPCOUNT);
  printf("##############################################\n");
  
  
  while(alltests[i].pass){
    crossfailed=0;
    result=1;
    fprintf(logFile,"--------------------------------------------------\n%s\n--------------------------------------------------\n",alltests[i].name);
    for(j=0;j<N;j++){
    	fprintf(logFile,"# Check: ");
      if(alltests[i].pass(logFile)){
	fprintf(logFile,"No errors occured during the %d. test.\n",j+1);
      	if(!alltests[i].fail(logFile)){
		fprintf(logFile,"# Crosscheck: Verified result\n");
		crossfailed++;
      	}
      	else {
		fprintf(logFile,"# Crosscheck: Coudn't verify result.\n");
      	}
      }
      else {
	fprintf(logFile,"--> Erroros occured during the %d. test.\n",j+1);
	result=0;
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
    fprintf(logFile,"Result for %s:\n",alltests[i].name);
    if(result){
      fprintf(logFile,"Directiv worked without errors.\nCrosschecks verified this result with %5.2f%% certainty.\n",100.0*crossfailed/N);
      printf("%s ... verified with %5.2f%% certainty\n",alltests[i].name,100.0*crossfailed/N);
    }
    else {
      fprintf(logFile,"Directive failed the tests!\n");
      printf("%s ... FAILED\n",alltests[i].name);
    }


    i++;
  }
  printf("\n\n Performed a total of %d tests, %d failed and %d successful with %d cross checked\nFor detailled inforamtion on the tests see the logfile (%s)",i,failed,success,crosschecked,logFileName);
  fprintf(logFile,"\n\n Performed a total of %d tests, %d failed and %d successful with %d cross checked\n",i,failed,success,crosschecked);
fclose(logFile);
return failed;
}

