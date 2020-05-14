<ompts:test>
<ompts:testdescription>Test which checks the detach clause of the omp task directive.</ompts:testdescription>
<ompts:ompversion>5.0</ompts:ompversion>
<ompts:directive>omp task detach,omp_fulfill_event</ompts:directive>
<ompts:dependences>omp task, omp atomic</ompts:dependences>
<ompts:testcode>
#include <stdio.h>
#include <math.h>
#include "omp_testsuite.h"
#include "omp_my_sleep.h"

<ompts:orphan:vars>
int result1 = 0;
int result2 = 0;
</ompts:orphan:vars>

int <ompts:testcode:functionname>omp_task_detach</ompts:testcode:functionname>(FILE * logFile){
result1 = 0;
result2 = 0;

#pragma omp parallel
{
#pragma omp master
    {
        <ompts:orphan>
            omp_event_handle_t event;
#pragma omp task shared(result1) <ompts:check>detach(event)</ompts:check>
        {
            <ompts:check>omp_fulfill_event(event);</ompts:check>
            result1 = 1;
        }
        </ompts:orphan>
#pragma omp taskwait

    }


#pragma omp master
    {

        <ompts:crosscheck>int dummy = 0;</ompts:crosscheck>
        omp_event_handle_t event;
#pragma omp task depend(out: result2) shared(result2) <ompts:check>detach(event)</ompts:check>
        {
            #pragma omp atomic
            result2++;
        }
#pragma omp task depend(out:result2) shared(result2) <ompts:crosscheck>depend(in:dummy)</ompts:crosscheck>
        {
            result2 *= 2;
        }
#pragma omp task shared(result2) <ompts:crosscheck>depend(out:dummy)</ompts:crosscheck>
        {
            my_sleep (SLEEPTIME);
            #pragma omp atomic
            result2++;
            <ompts:check>omp_fulfill_event(event);</ompts:check>
        }
#pragma omp taskwait
    }
}
    printf("result1: %d\n", result1);
    printf("result2: %d\n", result2);

    return (result1 == 1) && (result2 == 4);
}
</ompts:testcode>
</ompts:test>
