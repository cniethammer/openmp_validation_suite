<ompts:test>
<ompts:testdescription>Test the if clause of the omp task directive. The idea of the test is to generate a task in a single region and pause it immediately. The parent thread now shall set a counter variable which the paused task shall evaluate when woken up.</ompts:testdescription>
<ompts:ompversion>3.0</ompts:ompversion>
<ompts:directive>omp task if</ompts:directive>
<ompts:dependences>omp single,omp flush</ompts:dependences>
<ompts:testcode>
#include <stdio.h>
#include <math.h>
#include "omp_testsuite.h"
#include "omp_my_sleep.h"


int <ompts:testcode:functionname>omp_task_if</ompts:testcode:functionname>(FILE * logFile){
    <ompts:orphan:vars>
    int condition_false;
    int count;
    int result;    /* In case "omp task if" works, task will never be executed, therefore result would never be set */
    </ompts:orphan:vars>

    count = 0;
    result = 0;

    /* This will always evaluate to FALSE */
    condition_false = (logFile == NULL);
#pragma omp parallel 
{
#pragma omp single
    {
        <ompts:orphan>
#pragma omp task <ompts:check>if (condition_false)</ompts:check> shared(count, result)
        {
            /* Additionally use condition_false (being 0) to avoid compiler warnings (condition_false set, but not used) */
            my_sleep (SLEEPTIME_LONG + condition_false);
#pragma omp flush (count)
            printf("Inside the task directive count=%d", count);
            result = (0 == count);
            printf("result=%d", result);
        } /* end of omp task */
        </ompts:orphan>

        count = 1;
        printf("After thetask directive count=%d", count);
#pragma omp flush (count)

    } /* end of single */
} /*end of parallel */

    return result;
}
</ompts:testcode>
</ompts:test>
