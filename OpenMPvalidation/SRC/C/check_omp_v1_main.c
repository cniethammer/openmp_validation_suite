
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
{"check_has_openmp",check_has_openmp,crosscheck_has_openmp },
{"check_omp_get_num_threads",check_omp_get_num_threads,crosscheck_omp_get_num_threads },
{"check_omp_in_parallel",check_omp_in_parallel,crosscheck_omp_in_parallel },
{"for ORDERED",check_for_ordered,crosscheck_for_ordered },
{"for REDUCTION",check_for_reduction,crosscheck_for_reduction },
{"for PRIVATE",check_for_private,crosscheck_for_private},
{"for FIRSTPRIVATE",check_for_firstprivate,crosscheck_for_firstprivate},
{"for LASTPRIVATE",check_for_lastprivate,crosscheck_for_lastprivate},
{"section REDUCTION",check_section_reduction,crosscheck_section_reduction},
{"section PRIVATE",check_section_private,crosscheck_section_private},
{"section FIRSTPRIVATE",check_section_firstprivate,crosscheck_section_firstprivate},
{"section LASTPRIVATE",check_section_lastprivate,crosscheck_section_lastprivate},
{"SINGLE",check_single,crosscheck_single},
{"single PRIVATE",check_single_private,crosscheck_single_private},
{"SINGLE NOWAIT",check_single_nowait,crosscheck_single_nowait},
{"parallel for ORDERED",check_parallel_for_ordered,crosscheck_parallel_for_ordered },
{"parallel for REDUCTION",check_parallel_for_reduction,crosscheck_parallel_for_reduction },
{"parallel for PRIVATE",check_parallel_for_private,crosscheck_parallel_for_private},
{"parallel for FIRSTPRIVATE",check_parallel_for_firstprivate,crosscheck_parallel_for_firstprivate},
{"parallel for LASTPRIVATE",check_parallel_for_lastprivate,crosscheck_parallel_for_lastprivate},
{"parallel section REDUCTION",check_parallel_section_reduction,crosscheck_parallel_section_reduction},
{"parallel section PRIVATE",check_parallel_section_private,crosscheck_parallel_section_private},
{"parallel section FIRSTPRIVATE",check_parallel_section_firstprivate,crosscheck_parallel_section_firstprivate},
{"parallel section LASTPRIVATE",check_parallel_section_lastprivate,crosscheck_parallel_section_lastprivate},
{"omp MASTER",check_omp_master_thread,crosscheck_omp_master_thread },
{"omp CRITICAL",check_omp_critical,crosscheck_omp_critical },
{"omp ATOMIC",check_omp_atomic,crosscheck_omp_atomic },
{"omp BARRIER",check_omp_barrier,crosscheck_omp_barrier },
{"omp FLUSH",check_omp_flush,crosscheck_omp_flush },
{"omp THREADPRIVATE",check_omp_threadprivate,crosscheck_omp_threadprivate },
{"omp COPYIN",check_omp_copyin,crosscheck_omp_copyin },
{"omp LOCK",check_omp_lock,crosscheck_omp_lock},
{"omp TESTLOCK",check_omp_testlock,crosscheck_omp_testlock},
{"omp NEST_LOCK",check_omp_nest_lock,crosscheck_omp_nest_lock},
{"omp NEST_TESTLOCK",check_omp_nest_testlock,crosscheck_omp_nest_testlock},
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
  printf("######## OpenMP Validation Suite V 0.92 ######\n");
  printf("## Repetitions: %3d                       ####\n",N);
  printf("## Loop Count : %6d                    ####\n",LOOPCOUNT);
  printf("##############################################\n");
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

