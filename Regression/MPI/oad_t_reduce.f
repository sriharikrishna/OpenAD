        subroutine template()
          use OADtape
          use OADrev

!$TEMPLATE_PRAGMA_DECLARATIONS

          integer lroot
          integer lcount
          integer lId
          double precision t(count)

         if (our_rev_mode%plain) then
! original function
            call mpi_reduce( 
     +      sbuf%v,
     +      rbuf%v, 
     +      count, 
     +      datatype, 
     +      op, 
     +      root, 
     +      comm, 
     +      ierror)
          end if
          if (our_rev_mode%tape) then
! taping
          integer_tape(integer_tape_pointer) = count
          integer_tape_pointer = integer_tape_pointer+1
          integer_tape(integer_tape_pointer) = root
          integer_tape_pointer = integer_tape_pointer+1
          print *, sbuf(1:count)%v
            call mpi_reduce( 
     +      sbuf(1:count)%v,
     +      rbuf(1:count)%v, 
     +      count, 
     +      datatype, 
     +      op, 
     +      root, 
     +      comm, 
     +      ierror)
          end if 
          if (our_rev_mode%adjoint) then
! adjoint
             
          integer_tape_pointer = integer_tape_pointer-1
          lroot = integer_tape(integer_tape_pointer)
          integer_tape_pointer = integer_tape_pointer-1
          lcount = integer_tape(integer_tape_pointer)

          call MPI_COMM_RANK(comm, lId, ierror)
          if (lId.eq.lroot) then 
            t(1:count)=rbuf(1:count)%d
            rbuf(1:count)%d=0.0
          end if
          call mpi_bcast( 
     +      t(1:count), 
     +      lcount, 
     +      datatype, 
     +      lroot, 
     +      comm, 
     +      ierror)
          sbuf(1:count)%d=sbuf(1:count)%d+t
! don't need to do anything else for summation op
          end if 
        end subroutine template
