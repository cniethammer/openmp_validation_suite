#SUN Fortran Compiler:
FC=f90
FFLAGS=-xopenmp -O3
FLINKFLAGS=-O3 -xopenmp
OBJS= check_omp_v1_main.o omp_check_locks.o common_utility.o \
omp_check_critical_atomic.o omp_check_lib.o omp_check_do.o \
omp_check_section.o omp_check_single.o omp_check_parallel_do.o \
omp_check_parallel_section.o omp_check_master.o \
omp_check_threadprivate.o

OBJS2=omp_check_timing_functions.o check_omp_v2_main.o common_utility.o \
omp_check_num_threads.o omp_check_single_copyprivate.o

OBJS4= check_omp_schedule_main.o omp_check_lib.o omp_check_schedule.o \
common_utility.o

validation_suite_v1_fortran: $(OBJS) 
	$(FC) $(FLINKFLAGS) -o fortran_v1 $(OBJS)

v2_fortran: $(OBJS2) 
	$(FC) $(FLINKFLAGS) -o fortran_v2 $(OBJS2)

check_omp_schedule_main: $(OBJS4)
	$(FC) $(FLINKFLAGS) -o check_omp_schedule_main $(OBJS4)

check_omp_v1_main.o: check_omp_v1_main.f 
	$(FC) -c -o check_omp_v1_main.o check_omp_v1_main.f 

check_omp_v2_main.o: check_omp_v2_main.f 
	$(FC) -c -o check_omp_v2_main.o check_omp_v2_main.f 

check_omp_schedule_main.o:check_omp_schedule_main.f

omp_check_locks.o: omp_check_locks.f omp_testsuite.f common_utility.f

common_utility.o: common_utility.f omp_testsuite.f
	$(FC) -c -o common_utility.o common_utility.f 

omp_check_critical_atomic.o:common_utility.f omp_testsuite.f  common_utility.f 

omp_check_critical_atomic.o:omp_check_critical_atomic.f omp_testsuite.f \
common_utility.f

omp_check_lib.o: omp_check_lib.f omp_testsuite.f common_utility.f

omp_check_do.o:omp_check_do.f omp_testsuite.f common_utility.f

omp_check_section.o:omp_check_section.f omp_testsuite.f common_utility.f

omp_check_single.o: omp_check_single.f omp_testsuite.f common_utility.f

omp_check_parallel_do.o:omp_check_parallel_do.f omp_testsuite.f \
common_utility.f

omp_check_parallel_section.o:omp_check_parallel_section.f \
omp_testsuite.f common_utility.f

omp_check_master.o:omp_check_master.f omp_testsuite.f common_utility.f

omp_check_threadprivate.o:omp_check_threadprivate.f \
omp_testsuite.f common_utility.f

omp_check_schedule.o:omp_check_schedule.f omp_testsuite.f common_utility.f

omp_check_timing_functions.o:omp_check_timing_functions.f \
omp_testsuite.f common_utility.f

omp_check_num_threads.o: omp_check_num_threads.f \
omp_testsuite.f common_utility.f

omp_check_single_copyprivate.o:omp_check_single_copyprivate.f \
omp_testsuite.f common_utility.f

run: validation_suite_v1_fortran
	(OMP_NUM_THREADS=4; export OMP_NUM_THREADS; ./fortran_v1)
run2: v2_fortran
	(OMP_NUM_THREADS=4; export OMP_NUM_THREADS; ./fortran_v2)
run_schedule: check_omp_schedule_main
	(OMP_NUM_THREADS=4; export OMP_NUM_THREADS; ./check_omp_schedule_main)
clean:
	rm $(OBJS) && rm fortran_v1 
