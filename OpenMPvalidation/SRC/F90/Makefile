#SUN Fortran Compiler:
#FC=f90
#FFLAGS=-xopenmp -O3
#FLINKFLAGS=-O3 -xopenmp
#Intel Compiler
FC=ifort
FFLAGS=-openmp -O3
FLINKFLAGS=-O3 -openmp




OBJS= check_omp_v1_main.o omp_check_locks.o common_utility.o \
omp_check_critical_atomic.o omp_check_lib.o omp_check_do.o \
omp_check_section.o omp_check_single.o omp_check_parallel_do.o \
omp_check_parallel_section.o omp_check_master.o \
omp_check_threadprivate.o

OBJS2=omp_check_timing_functions.o check_omp_v2_main.o common_utility.o \
omp_check_num_threads.o omp_check_single_copyprivate.o

OBJS3=check_num_threads.o get_wticks.o get_wtime.o check_single_copyprivate.o \
common_utility.o

OBJS4= check_omp_schedule_main.o omp_check_lib.o omp_check_schedule.o \
common_utility.o

OBJS10= omp_check_chunksize.o omp_check_lib.o common_utility.o

default: 
	@echo "Possible Targets are:"
	@echo " fortran_v1  - build omp version 1 tests"
	@echo " fortran_v2  - build omp version 2 tests"
	@echo " check_omp_schedule_main  - build schedule clause tests"
	@echo " check_chunksize - build chunksite tests (internal use)"
	@echo " all       - build all binaries"


all: fortran_v1 fortran_v2 check_omp_schedule_main check_chunksize

fortran_v1: $(OBJS) 
	$(FC) $(FLINKFLAGS) -o fortran_v1 $(OBJS)

fortran_v2: $(OBJS2) 
	$(FC) $(FLINKFLAGS) -o fortran_v2 $(OBJS2)

omp_v2: $(OBJS2) $(OBJS3)
	$(FC) $(FLINKFLAGS) -o check_num_threads omp_check_num_threads.o check_num_threads.o common_utility.o
	$(FC) $(FLINKFLAGS) -o check_single_copyprivate omp_check_single_copyprivate.o check_single_copyprivate.o common_utility.o
	$(FC) $(FLINKFLAGS) -o get_wticks omp_check_timing_functions.o get_wticks.o common_utility.o
	$(FC) $(FLINKFLAGS) -o get_wtime omp_check_timing_functions.o get_wtime.o common_utility.o

check_omp_schedule_main: $(OBJS4)
	$(FC) $(FLINKFLAGS) -o check_omp_schedule_main $(OBJS4)

check_chunksize: $(OBJS10)
	$(FC) $(FLINKFLAGS) -o check_chunksize $(OBJS10)

check_omp_v1_main.o: check_omp_v1_main.f 
	$(FC) -c -o check_omp_v1_main.o check_omp_v1_main.f 

check_omp_v2_main.o: check_omp_v2_main.f 
	$(FC) -c -o check_omp_v2_main.o check_omp_v2_main.f 

check_omp_schedule_main.o:check_omp_schedule_main.f common_utility.f

check_single_copyprivate.o: check_single_copyprivate.f common_utility.f

get_wticks.o: get_wticks.f common_utility.f

get_wtime.o: get_wtime.f common_utility.f

check_num_threads.o: check_num_threads.f common_utility.f

omp_check_locks.o: omp_check_locks.f omp_testsuite.f common_utility.f

common_utility.o: common_utility.f omp_testsuite.f
	$(FC) -c -o common_utility.o common_utility.f 

check_chunksize.o: omp_check_chunksize.f omp_testsuite.f common_utility.f
	$(FC) -c -o omp_check_chunksize.o omp_check_chunksize.f \
            omp_testsuite.f common_utility.f

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
	(OMP_NUM_THREADS=4; export OMP_NUM_THREADS;OMP_NESTED=TRUE;export OMP_NESTED;./fortran_v1)
run2: v2_fortran
	(OMP_NUM_THREADS=4; export OMP_NUM_THREADS; ./fortran_v2)
run_schedule: check_omp_schedule_main
	(OMP_NUM_THREADS=4; export OMP_NUM_THREADS; ./check_omp_schedule_main)
chunksize: check_chunksize
	(OMP_NUM_THREADS=4; export OMP_NUM_THREADS; ./check_chunksize)
clean:
	rm $(OBJS) && rm fortran_v1 
