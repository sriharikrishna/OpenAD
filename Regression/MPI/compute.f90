subroutine compute(x,f)
 use mpi
 implicit none
 double precision  x, f
 integer ierr
 call ring(x) 
 call MPI_REDUCE(x,f,1,MPI_DOUBLE_PRECISION,MPI_SUM,0,&
      MPI_COMM_WORLD,ierr)
end
