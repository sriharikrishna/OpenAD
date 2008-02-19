        subroutine template()
          use OADtape
          use OADrev
!$TEMPLATE_PRAGMA_DECLARATIONS

          integer lcount
          integer ldest
          integer iaddr
          external iaddr
          double precision, dimension(:), pointer :: t

         if (our_rev_mode%plain) then
! original function
            call mpi_isend( 
     +      buf,  
     +      count*2, 
     +      datatype, 
     +      dest, 
     +      tag, 
     +      comm, 
     +      request, 
     +      ierror)
          end if
          if (our_rev_mode%tape) then
! taping
          integer_tape(integer_tape_pointer) = count
          integer_tape_pointer = integer_tape_pointer+1
          integer_tape(integer_tape_pointer) = dest
          integer_tape_pointer = integer_tape_pointer+1
            call mpi_isend( 
     +      buf,  
     +      count*2, 
     +      datatype, 
     +      dest, 
     +      tag, 
     +      comm, 
     +      request, 
     +      ierror)
          end if 
          if (our_rev_mode%adjoint) then
! adjoint
          integer_tape_pointer = integer_tape_pointer-1
          ldest = integer_tape(integer_tape_pointer)
          integer_tape_pointer = integer_tape_pointer-1
          lcount = integer_tape(integer_tape_pointer)
          call oadtirecv(
     +      buf,  
     +      lcount*2, 
     +      datatype, 
     +      ldest, 
     +      tag, 
     +      comm, 
     +      request, 
     +      ierror)
          end if 
        end subroutine template
