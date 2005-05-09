	SUBROUTINE init()
	real:: x = 0.0
!$omp threadprivate(x)

!$omp single 
	x = 1.0
!$omp end single copyprivate(x)
	end

	program main
!$omp parallel
	call init()
!$omp end parallel
	end program main
