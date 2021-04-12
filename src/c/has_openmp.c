<ompts:test>
<ompts:testdescription>Test which checks the OpenMp support.</ompts:testdescription>
<ompts:ompversion>1.0</ompts:ompversion>
<ompts:directive>_OPENMP</ompts:directive>
<ompts:testcode>
#include <stdio.h>

#include "omp_testsuite.h"

int <ompts:testcode:functionname>has_openmp</ompts:testcode:functionname>(FILE * logFile){
    int rvalue = 0;
    <ompts:check>
#ifdef _OPENMP
    fprintf(logFile, "OpenMP version %d\n", _OPENMP);
    switch(_OPENMP) {
        /* C, C++, Fortran specs */
        case 202011: /* 5.1 */
        case 201811: /* 5.0 */
        case 201511: /* 4.5 */
        case 201307: /* 4.0 */
        case 201107: /* 3.1 */
        case 200805: /* 3.0 */
        case 200505: /* 2.5 */
	        rvalue = 1;
            break;
        /* C, C++ only specs */
        case 200203: /* 2.0 */
        case 199810: /* 1.0 */
	        rvalue = 1;
            break;
        /* Fortran only specs */
        case 199710: /* 2.0 */
        case 199911: /* 1.1 */
        case 200011: /* 1.0 */
	        rvalue = 1;
            break;
        default:
	        rvalue = 0;
            fprintf(logFile, "ERROR: Unknown OpenMP version.\n");
            break;
    }

#endif
    </ompts:check>
    <ompts:crosscheck>
    </ompts:crosscheck>
	return (rvalue);
}
</ompts:testcode>
</ompts:test>
