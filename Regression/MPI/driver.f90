program driver
 use mpi
 implicit none
 double precision  x, f
 integer myid, numprocs, i, rc, ierr
 double precision, dimension(:), allocatable :: x0
 call MPI_INIT(ierr)
 call MPI_COMM_RANK(MPI_COMM_WORLD, myid, ierr)
 call MPI_COMM_SIZE(MPI_COMM_WORLD, numprocs, ierr)
 x=myid*0.5
 call ring(x) 
 call MPI_REDUCE(x,f,1,MPI_DOUBLE_PRECISION,MPI_SUM,0,&
      MPI_COMM_WORLD,ierr)
 ! node 0 prints the answer.
 if (myid .eq. 0) then
    write(6, *) f
 endif
 call MPI_FINALIZE(rc)
end




