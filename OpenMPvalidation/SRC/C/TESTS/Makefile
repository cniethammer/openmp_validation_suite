# Make file for the OpenMP validation suite C version
# uncomment the desired compiler and compilation flags
# change NUM_THREADS to desired value

# the number of threads this validation suite will use
NUM_THREADS= 2

# Fujitsu Compilers:
#CC = fcc
#CFLAGS = -KOMP,fast_GP2=2

# PGI compilers
#
#CC = pgcc
#CFLAGS = -fast -mp 

# Intel compilers:
#
#CC = ecc
#CC = icc
#CFLAGS = -O3 -ipo -openmp
#CFLAGS = -Wall -O0 -openmp
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
#CFLAGS = -mp -lm 

# IBM compilers:
#CC = xlc_r
#CFLAGS = -qsmp=omp -lm
#

# SUN compilers
#CC = cc
#CFLAGS = -xopenmp -lm

#
# open64 compilers
#CC = opencc
#CFLAGS = -mp -Ofast -lm

#Pathscale compilers
#CC = pathcc
#CFLAGS = -mp -Ofast -lm

ifdef testfile
TESTFILE = $(testfile)
endif

ifdef TESTFILE
 TEST_FILENAME = $(TESTFILE)
else
 TEST_FILENAME = OMP1_TEST
endif

.PHONEY:print_help
print_help:
	@echo "----------------------------------"
	@echo "Edit Makefile for proper compiler command and options"
	@echo "usage: "
	@echo "      gmake test TESTFILE=filename"
	@echo "Or    gmake test                 "
	@echo " Then:							"
	@echo "      gmake run                  "
	@echo " Clean up:                       "
	@echo "      gmake clean                "
	@echo "----------------------------------"
	@echo "filename may be one of the following:"
	@echo "OMP1_TES       - execute omp version 1 tests"
	@echo "OMP2_TEST      - execute omp version 2 tests"
	@echo "CUSTOM_TEST    - execute customized tests"
	@echo "the default filename is OMP1_TEST"

default:print_help

.PHONY: test
test:main

# precompilation tries to generate .o files for feasible tests
# A header is generated from available .o files
feasible_test.h:
	 ./preCompilation $(TEST_FILENAME) $(CC) $(CFLAGS)

#compile main.c and link with other objects to get  executables
main:feasible_test.h
	$(CC) $(CFLAGS) -o main main.c *.o
	
clean:
	rm -f *.o failed.compilation feasible_test.h main test.log *~ 

run:main 
	-rm -f test.log 
	(OMP_NUM_THREADS=$(NUM_THREADS); export OMP_NUM_THREADS; ./main)

