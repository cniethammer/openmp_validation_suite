      integer function check_do_schedule()
      implicit none
      intrinsic ceiling
      integer omp_get_thread_num
      integer, parameter::MAX_SIZE=1000
      integer i;
      integer chunk
      integer rank;
      integer a(1:MAX_SIZE)
      include "omp_testsuite.f"
!$omp parallel private(rank)
      rank=omp_get_thread_num();
!$omp do schedule(static)     
      do i=1,MAX_SIZE
	a(i)=rank
      enddo
!$omp end do
!$omp end parallel
      check_do_schedule=1 
      chunk=MAX_SIZE/4
      do i=1,MAX_SIZE        
        if(A(i).ne.Ceiling(real(i)/real(chunk))-1) then
           check_do_schedule=0
           exit
        endif
      end do
      end
