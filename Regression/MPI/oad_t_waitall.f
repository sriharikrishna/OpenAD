        subroutine template()
          use OADtape
          use OADrev

!$TEMPLATE_PRAGMA_DECLARATIONS

          integer iaddr
          external iaddr

         if (our_rev_mode%plain) then
! original function
            call mpi_waitall( 
     +      count, 
     +      requests, 
     +      statuses, 
     +      ierror)
          end if
          if (our_rev_mode%tape) then
! taping
            call mpi_waitall( 
     +      count, 
     +      requests, 
     +      statuses, 
     +      ierror)
          end if 
          if (our_rev_mode%adjoint) then
! adjoint
! do nothing
          end if 
        end subroutine template
