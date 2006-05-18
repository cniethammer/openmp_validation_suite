# General Makefile containing all the necessary compiler flags for the tests

# modify CC and CFLAGS for OpenMP c compilers
# modify FC and FFLAGS for OpenMP Fortran compilers


# Content:
#########################################################
 
# 1. basic usage
# 2. Compiler selection and Flags

#########################################################


#########################################################
# 1. basic usage
#########################################################
# 	make ctest		generate c test "ctest"
# 	make ftest		generate fortran test "ftest"
#	make clean		removes all sources and binaries
# 	make cleanall	removes sources,binaries and logfiles


#########################################################
# 2. Compiler selection and Flags
#########################################################

# Fujitsu Compilers:
#CC = fcc
#CFLAGS = -KOMP,fast_GP2=2
#FC=frt
#FFLAGS=-KOMP,fast_GP2=2 -w -Am -X9 -Fixed


# PGI compilers
#CC = pgcc
#CFLAGS = -mp
#CFLAGS = -mp -DVERBOSE
#CFLAGS = -fast -mp

#FC = pgf90
#FFLAGS = -fast -mp
#FFLAGS = -mp -g


# Intel compilers:
#CC = ecc
#CC = icc
#CC = omcc
#CFLAGS = -O3 -ip -openmp
#CFLAGS = -Wall -O0 -openmp
#CFLAGS =  -openmp -lm
#CFLAGS =  -openmp -lm -DVERBOSE

#FC = ifort
#FFLAGS = -openmp -lm


# Omni compilers:
#CC = ompcc
#CFLAGS = -O3 -lm 


# Assure compilers:
#CC = assurec
#CFLAGS = -O3 -WApname=project -DUSE_ASSURE=1
#FC =
#FFLAGS =

# NEC:
#CC = c++ 
#CC = sxc++ 
#CFLAGS = -Popenmp

#FC=sxf90
#FFLAGS= -Popenmp


# Hitachi:
#CC = xcc 
#CFLAGS = -O4 -pvec +Op -parallel -omp
#FC =
#FFLAGS =


# SGI:
#CC = cc
#CFLAGS = -mp -lm 
#FC =
#FFLAGS =


# IBM compilers:
#CC = xlc_r
#CFLAGS = -qsmp=omp -lm


#FC=xlf90_r
#FFLAGS=-qsmp=omp -qfixed=132 -qlanglvl=extended


# SUN compilers
#CC = cc
#CFLAGS = -fast -xopenmp -lm

#FC =f90
#FFLAGS = -xopenmp -fast -lm


# open64 compilers
# remark: -I. was a workaround because the installation came without omp.h file
#CC = opencc
#CFLAGS = -O0 -openmp -lm -I. -lomp -lpthread
#FC =
#FFLAGS =


#Pathscale Compiler
#CC = pathcc
#CFLAGS = -mp -Ofast -lm

#FC=pathf90
#FFLAGS= -mp -Ofast -lm







default: omp_testsuite.h
	make test1

omp_testsuite.h:
	./ompts_makeHeader.pl

ctest:
	./runtest.pl -lang=c -d=c testlist-c.txt
ftest:
	./runtest.pl -lang=fortran -d=fortran testlist-f.txt

print_compile_options:
	@echo "C compiler: $(CC)"
	$(CC) --version
	@echo "CFLAGS: $(CFLAGS)"
	@echo ""
	@echo ""
	@echo "Fortran compiler: $(FC)"
	$(FC) --version
	@echo "FFLAGS: $(FFLAGS)"

test1:
	./ompts_parser.pl templates/omp_for_ordered.tpl -test
	./ompts_parser.pl templates/omp_for_ordered.tpl -crosstest
	icc -openmp -o test_omp_for_ordered test_omp_for_ordered.c
	icc -openmp -o crosstest_omp_for_ordered crosstest_omp_for_ordered.c


clean:
	-find . -name "[cf]test*" -maxdepth 1 -perm +111 -exec rm {} \;
	-find . -name "[cf]crosstest*" -maxdepth 1 -perm +111 -exec rm {} \;
	-find . -name "[cf]ctest*" -maxdepth 1 -perm +111 -exec rm {} \;
	-find . -name "[cf]orphan*" -maxdepth 1 -perm +111 -exec rm {} \;
	-rm [cf]test*.[cf] [cf]crosstest*.[cf] [cf]ctest*.[cf] [cf]orphan*.[cf]

cleanlogs:
	-rm *.log *.out

cleanresults:
	-rm results.txt

cleanall: clean cleanlogs cleanresults
