# PGI compilers
#
#CC = pgcc
#CFLAGS = -fast -mp 

# Intel compilers:
#
#CC = ecc
CC = icc
#CC = omcc
#CFLAGS = -O3 -ip -openmp
CFLAGS = -O0 -openmp
#CFLAGS =  -openmp

# Omni compilers:
#
#CC = ompcc
#CFLAGS = -O3 -lm 

# Assure compilers:
#
#CC = assurec
#CFLAGS = -O3 -WApname=project -DUSE_ASSURE=1

# NEC:
#
#CC = c++ 
#CC = sxc++ 
#CFLAGS = -Popenmp

#
# Hitachi:
#
#CC = xcc 
#CFLAGS = -O4 -pvec +Op -parallel -omp
#
# SGI:
#
#
#CC = cc
#CFLAGS = -mp 

# IBM compilers:
#CC = xlc_r
#CFLAGS = -qsmp=omp
#
# SUN compilers
#CC = cc
#CFLAGS = -xopenmp


OBJECTS = check_omp_v1_main.o omp_check_lib.o omp_check_for.o \
          omp_check_section.o omp_check_single.o omp_check_parallel_for.o \
          omp_check_parallel_section.o omp_check_master.o \
          omp_check_critical_atomic.o omp_check_threadprivate.o \
          omp_check_locks.o omp_check_reduction.o omp_check_schedule.o

OBJECTS2 = check_omp_v2_main.o omp_check_lib.o omp_check_single_copyprivate.o \
           omp_check_threadprivate.o omp_check_for.o omp_check_num_threads.o \
           omp_check_timing_functions.o 

OBJECTS4 = check_omp_schedule_main.o omp_check_lib.o omp_check_schedule.o        
OBJECTS10 = omp_check_chunksize.o 

default: check_omp_v1_main

all:  check_omp_v1_main check_omp_v2_main check_omp_schedule_main check_chunksize


check_omp_v1_main: $(OBJECTS)
	$(CC) $(CFLAGS) -o check_omp_v1_main $(OBJECTS)

check_omp_v2_main: $(OBJECTS2)
	$(CC) $(CFLAGS) -o check_omp_v2_main $(OBJECTS2)

check_omp_schedule_main: $(OBJECTS4)
	$(CC) $(CFLAGS) -o check_omp_schedule_main $(OBJECTS4)

check_chunksize: $(OBJECTS10)
	$(CC) $(CFLAGS) -o check_chunksize $(OBJECTS10)


clean:
	rm -f $(OBJECTS) $(OBJECTS2) $(OBJECTS4) $(OBJECTS10) check_omp_v1_main check_omp_v2_main check_omp_schedule_main check_chunksize *~ 


run: check_omp_v1_main
	rm test.log -f
	(OMP_NUM_THREADS=2; export OMP_NUM_THREADS; ./check_omp_v1_main)

run2: check_omp_v2_main
	(OMP_NUM_THREADS=2; export OMP_NUM_THREADS; ./check_omp_v2_main)

schedule: check_omp_schedule_main
	(OMP_NUM_THREADS=2; export OMP_NUM_THREADS; ./check_omp_schedule_main)

chunksize: check_chunksize
	(OMP_NUM_THREADS=2; export OMP_NUM_THREADS; ./check_chunksize)
