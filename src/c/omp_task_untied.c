<ompts:test>
<ompts:testdescription>Test which checks the untied clause of the omp task directive. The idear of the tests is to generate a set of tasks in a single region. We create more tasks than threads exist, so at least one thread should handle more than one thread. Then we send the half of the threads into a bussy loop. We let finish the other threads. Now we should get rescheduled some untied tasks to the idle threads.</ompts:testdescription>
<ompts:ompversion>3.0</ompts:ompversion>
<ompts:directive>omp task untied</ompts:directive>
<ompts:dependences>omp single, omp flush</ompts:dependences>
<ompts:testcode>
#include <stdio.h>
#include <stdlib.h>
#include "omp_testsuite.h"
#include "omp_my_sleep.h"

int <ompts:testcode:functionname>omp_task_untied</ompts:testcode:functionname>(FILE * logFile){
    int i;
    <ompts:orphan:vars>
    int result = 0;
    int started = 0;
    int state_init = 1;
    int state_run = 1;
    int num_tasks = 0;
    int num_threads;
    int max_num_tasks;
    int *start_tids; /* array holding for each thread the id of the first executing thread */
    </ompts:orphan:vars>


    #pragma omp parallel 
    {
        #pragma omp single nowait
        {
            num_threads = omp_get_num_threads();
            max_num_tasks = num_threads * MAX_TASKS_PER_THREAD;
            start_tids = (int *) malloc(max_num_tasks * sizeof(int));
            for (i = 0; i < max_num_tasks; i++) {
                start_tids[i] = -1; /* mark as not assigned */
            }

            for (i = 0; i < max_num_tasks; i++) {
                <ompts:orphan>
#               pragma omp task <ompts:check>untied</ompts:check> private(i)
                {

                    if (start_tids[i] == -1) { /* initial thread assignement */
                        start_tids[i] = omp_get_thread_num();
#                       pragma omp atomic
                        num_tasks++;

                    } 
                    else {
                        fprintf(logFile, "Ecountered reassignment of task with task restart.\n");
#                       pragma omp atomic
                        result++;
                    }

                    /* Wait untill all tasks are generated or timeout for initialization is reached.
                     * The timeout is needed, as the runtime may only allow a limited number of 
                     * tasks to be submitted to the execution queue - which is smaller than the number 
                     * of tasks we want to generate. */
                    while (num_tasks < max_num_tasks && state_init) {
                        my_sleep (SLEEPTIME);
#                       pragma omp flush (num_tasks)
#                       pragma omp flush (state_init)
                    }


                    /* Suspend every second task */
                    if ((i % 2) == 0) {
                        do {
                            int current_tid;
                            my_sleep (SLEEPTIME);
                            current_tid = omp_get_thread_num ();
                            if (current_tid != start_tids[i]) {
                                fprintf(logFile, "Ecountered reassignment of task during task execution.\n");
#                               pragma omp atomic
                                result++;
                                break;
                            }
#                           pragma omp flush (state_run)
                        } while (state_run);
                    } 
                } /* end of omp task */
                </ompts:orphan>
            } /* end of for */

            /* wait until all tasks have been created and were sheduled at least
             * a first time  or timeout is reached */
            while (num_tasks < max_num_tasks && state_init) {
                my_sleep (SLEEPTIME);
#               pragma omp flush (num_tasks)
#               pragma omp flush (state_init)
            }
        } /* end of single */

        my_sleep(SLEEPTIME_LONG/2);
        fprintf(logFile, "Timeout init\n");
        state_init = 0;
#       pragma omp flush (state_init)
        /* wait a little moment more until we stop the test */
        my_sleep(SLEEPTIME_LONG/2);
        fprintf(logFile, "Timeout execution\n");
        state_run = 0;
#       pragma omp flush (state_run)
    } /* end of parallel */

    fprintf(logFile, "Detected %d reassginments of tasks.\n", result);
    return (result > 0);
} 
</ompts:testcode>
</ompts:test>
