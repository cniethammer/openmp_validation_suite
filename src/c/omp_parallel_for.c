<ompts:test>
<ompts:testdescription>Test which checks the omp parallel for directive.</ompts:testdescription>
<ompts:ompversion>1.0</ompts:ompversion>
<ompts:directive>omp parallel for</ompts:directive>
<ompts:dependences></ompts:dependences>
<ompts:testcode>
#include "omp_testsuite.h"

#include <stdio.h>

int <ompts:testcode:functionname>omp_parallel_for</ompts:testcode:functionname>(FILE * logFile){
    int i;
    int data[LOOPCOUNT];

<ompts:check>#pragma omp parallel for</ompts:check>
    for (i = 0; i < LOOPCOUNT; i++)
    {
        data[i] = i;
    }

    for (i = 0; i < LOOPCOUNT; i++)
    {
        if (data[i] != i) return 0;
    }
    return 1;
}
</ompts:testcode>
</ompts:test>
