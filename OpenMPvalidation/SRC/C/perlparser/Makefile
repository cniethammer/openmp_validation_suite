# Fujitsu Compilers:
#CC = fcc
#CFLAGS = -KOMP,fast_GP2=2

# PGI compilers
#
#CC = pgcc
#CFLAGS = -mp
#CFLAGS = -mp -DVERBOSE
#CFLAGS = -fast -mp

#FC = pgf90
#FFLAGS = -fast -mp
# Intel compilers:
#
#CC = ecc
#CC = icc
#CC = omcc
#CFLAGS = -O3 -ip -openmp
#CFLAGS = -Wall -O0 -openmp
#CFLAGS =  -openmp -lm
#CFLAGS =  -openmp -lm -DVERBOSE

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
#CFLAGS = -fast -xopenmp -xvpara -lm
#
# open64 compilers
# remark: -I. was a workaround because the installation came without omp.h file
#CC = opencc
#CFLAGS = -O0 -openmp -lm -I. -lomp -lpthread


default: omp_testsuite.h
	make test1

omp_testsuite.h:
	./ompts_makeHeader.pl

test1:
	./ompts_parser.pl templates/omp_for_ordered.tpl -test
	./ompts_parser.pl templates/omp_for_ordered.tpl -crosstest
	icc -openmp -o test_omp_for_ordered test_omp_for_ordered.c
	icc -openmp -o crosstest_omp_for_ordered crosstest_omp_for_ordered.c


clean:
	-find . -name "[cf]test*" -maxdepth 1 -perm 700 -exec rm {} \;
	-find . -name "[cf]crosstest*" -maxdepth 1 -perm 700 -exec rm {} \;
	-find . -name "[cf]orphan*" -maxdepth 1 -perm 700 -exec rm {} \;
	-rm [cf]test*.[cf] [cf]crosstest*.[cf] [cf]orphan*.[cf]

cleanlogs:
	-rm *.log *.out

cleanall: clean cleanlogs	
