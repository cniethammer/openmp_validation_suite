<ompts:test>
<ompts:testdescription>Test taskyield directive. First generate a set of tasks and pause it immediately. Then we resume half of them and check whether they are scheduled by different threads</ompts:testdescription>
<ompts:ompversion>3.0</ompts:ompversion>
<ompts:directive>omp taskyield</ompts:directive>
<ompts:dependences>omp taskwait</ompts:dependences>
<ompts:testcode>
#include <stdio.h>
#include <math.h>
#include "omp_testsuite.h"
#include "omp_my_sleep.h"
#include "timer.h"


int <ompts:testcode:functionname>omp_taskyield</ompts:testcode:functionname>(FILE * logFile){

  <ompts:orphan:vars>
    int go=0;
    double main_task_finish_time=0;
    double long_child_finish_time=0;
  </ompts:orphan:vars>
  
  
  #pragma omp parallel num_threads(2)
  {
    #pragma omp single nowait
    {      <ompts:orphan>
               #pragma omp task   
               { fprintf(logFile," %lf create parent task by thread %d\n",timer(),omp_get_thread_num());                
                   #pragma omp task shared(go)
                   {
                  fprintf(logFile," %lf create small task by thread %d\n",timer(),omp_get_thread_num());  
                       while (go<1)
                         {
                         }// end of while
                          my_sleep (SLEEPTIME);
                  fprintf(logFile," %lf finish small task by thread %d\n",timer(),omp_get_thread_num());
                   }

                  #pragma omp task shared(go)
                   {
                   fprintf(logFile," %lf create big task by thread %d\n",timer(),omp_get_thread_num());
                   go=1;
                   my_sleep(SLEEPTIME_LONG);
                   long_child_finish_time=timer();
                   fprintf(logFile," %lf finish big task by thread %d\n",timer(),omp_get_thread_num());
                   }



                  <ompts:check>#pragma omp taskyield</ompts:check> 
                  my_sleep (SLEEPTIME);
                  main_task_finish_time=timer();
                 fprintf(logFile," %lf finish parent task by thread %d\n",timer(),omp_get_thread_num());
               }/* end of omp main task */
  
          
        </ompts:orphan>
    } /* end of single */
  } /* end of parallel */

  return (main_task_finish_time>long_child_finish_time);
}
</ompts:testcode>

</ompts:test>
