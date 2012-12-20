!#########################################################
! This file is part of OpenAD released under the LGPL.   #
! The full COPYRIGHT notice can be found in the top      #
! level directory of the OpenAD distribution             #
!#########################################################

C Checkpoint counter functions---------------------

      subroutine countcheckpoint()
C $OpenAD$ INLINE DECLS
        use OAD_tape
        implicit none
        integer theSwitch 
C $OpenAD$ END DECLS
        if(theSwitch.eq.0) then
          print *,"Checkpoint storage"
          print *, "Floating point: ", oad_dt_ptr
          print *, "Integer: ", oad_it_ptr
          print *, "Boolean: ", oad_lt_ptr
          print *, "String: ", oad_st_ptr
          theSwitch = 1
        end if
      end subroutine
        

C Counter functions -------------------------------

       subroutine countmult(x)
C $OpenAD$ INLINE DECLS
         use OAD_active
         implicit none
         integer x
C $OpenAD$ END DECLS
         count_mult = count_mult + x
       end subroutine

       subroutine countadd(x)
C $OpenAD$ INLINE DECLS
         use OAD_active
         implicit none
         integer x
C $OpenAD$ END DECLS
         count_add = count_add + x
       end subroutine




C taping --------------------------------------------


      subroutine push_s0(x)
C $OpenAD$ INLINE DECLS
      use OAD_tape
      implicit none
      double precision :: x
C $OpenAD$ END DECLS
      if(oad_dt_sz .lt. oad_dt_ptr) call oad_dt_grow()
      oad_dt(oad_dt_ptr)=x; oad_dt_ptr=oad_dt_ptr+1
      end subroutine 

      subroutine pop_s0(x)
C $OpenAD$ INLINE DECLS
      use OAD_tape
      implicit none
      double precision :: x
C $OpenAD$ END DECLS
      oad_dt_ptr=oad_dt_ptr-1
      x=oad_dt(oad_dt_ptr)
      end subroutine

      subroutine push_s1(x)
C $OpenAD$ INLINE DECLS
      use OAD_tape
      implicit none
      double precision :: x(:)
C $OpenAD$ END DECLS
      oad_chunk_size=size(x,1)
      if(oad_dt_sz .lt. oad_dt_ptr+oad_chunk_size)
     + call oad_dt_grow()
      oad_dt(oad_dt_ptr:oad_dt_ptr+oad_chunk_size-1)=
     +x
      oad_dt_ptr=oad_dt_ptr+oad_chunk_size
      end subroutine 

      subroutine pop_s1(x)
C $OpenAD$ INLINE DECLS
      use OAD_tape
      implicit none
      double precision :: x(:)
C $OpenAD$ END DECLS
      oad_chunk_size=size(x,1)
      oad_dt_ptr=oad_dt_ptr-oad_chunk_size
      x=oad_dt(oad_dt_ptr:oad_dt_ptr+oad_chunk_size-1)
      end subroutine

      subroutine push_s2(x)
C $OpenAD$ INLINE DECLS
      use OAD_tape
      implicit none
      double precision :: x(:,:)
C $OpenAD$ END DECLS
      oad_chunk_size=size(x,1)*size(x,2)
      if(oad_dt_sz .lt. oad_dt_ptr+oad_chunk_size) 
     + call oad_dt_grow()
      oad_dt(oad_dt_ptr:oad_dt_ptr+oad_chunk_size-1)=
     +reshape(x,(/oad_chunk_size/))
      oad_dt_ptr=oad_dt_ptr+oad_chunk_size
      end subroutine 

      subroutine pop_s2(x)
C $OpenAD$ INLINE DECLS
      use OAD_tape
      implicit none
      double precision :: x(:,:)
C $OpenAD$ END DECLS
      oad_chunk_size=size(x,1)*size(x,2)
      oad_dt_ptr=oad_dt_ptr-oad_chunk_size
        x=reshape(oad_dt(oad_dt_ptr:oad_dt_ptr+oad_chunk_size-1),
     +shape(x))
      end subroutine

      subroutine apush(x)
C $OpenAD$ INLINE DECLS
      use OAD_tape
      use OAD_active
      implicit none
      type(active) :: x
C $OpenAD$ END DECLS
      if(oad_dt_sz .lt. oad_dt_ptr) call oad_dt_grow()
      oad_dt(oad_dt_ptr)=x%v; oad_dt_ptr=oad_dt_ptr+1
      end subroutine 

      subroutine apop(x)
C $OpenAD$ INLINE DECLS
      use OAD_tape
      use OAD_active
      implicit none
      type(active) :: x
C $OpenAD$ END DECLS
      oad_dt_ptr=oad_dt_ptr-1
      x%v=oad_dt(oad_dt_ptr)
      end subroutine

      subroutine push_i_s0(x)
C $OpenAD$ INLINE DECLS
      use OAD_tape
      implicit none
      integer :: x
C $OpenAD$ END DECLS
      if(oad_it_sz .lt. oad_it_ptr) call oad_it_grow()
      oad_it(oad_it_ptr)=x; oad_it_ptr=oad_it_ptr+1
      end subroutine 

      subroutine pop_i_s0(x)
C $OpenAD$ INLINE DECLS
      use OAD_tape
      implicit none
      integer :: x
C $OpenAD$ END DECLS
      oad_it_ptr=oad_it_ptr-1
      x=oad_it(oad_it_ptr)
      end subroutine

      subroutine push_i_s1(x)
C $OpenAD$ INLINE DECLS
      use OAD_tape
      implicit none
      integer :: x(:)
C $OpenAD$ END DECLS
      oad_chunk_size=size(x,1)
      if(oad_it_sz .lt. oad_it_ptr+oad_chunk_size) 
     +call oad_it_grow()
      oad_it(oad_it_ptr:oad_it_ptr+oad_chunk_size-1)=
     +x 
      oad_it_ptr=oad_it_ptr+oad_chunk_size
      end subroutine 

      subroutine pop_i_s1(x)
C $OpenAD$ INLINE DECLS
      use OAD_tape
      implicit none
      integer :: x(:)
C $OpenAD$ END DECLS
      oad_chunk_size=size(x,1)
      oad_it_ptr=oad_it_ptr-oad_chunk_size
      x=oad_it(oad_it_ptr:oad_it_ptr+oad_chunk_size-1)
      end subroutine

      subroutine push_i_s2(x)
C $OpenAD$ INLINE DECLS
      use OAD_tape
      implicit none
      integer :: x(:,:)
C $OpenAD$ END DECLS
      oad_chunk_size=size(x,1)*size(x,2)
      if(oad_it_sz .lt. oad_it_ptr+oad_chunk_size) 
     + call oad_it_grow()
      oad_it(oad_it_ptr:oad_it_ptr+oad_chunk_size-1)=
     +reshape(x,(/oad_chunk_size/))
      oad_it_ptr=oad_it_ptr+oad_chunk_size
      end subroutine 

      subroutine pop_i_s2(x)
C $OpenAD$ INLINE DECLS
      use OAD_tape
      implicit none
      integer :: x(:,:)
C $OpenAD$ END DECLS
      oad_chunk_size=size(x,1)*size(x,2)
      oad_it_ptr=oad_it_ptr-oad_chunk_size
        x=reshape(oad_it(oad_it_ptr:oad_it_ptr+oad_chunk_size-1),
     +shape(x))
      end subroutine

      subroutine push_b(x)
C $OpenAD$ INLINE DECLS
      use OAD_tape
      implicit none
      logical :: x
C $OpenAD$ END DECLS
      if(oad_lt_sz .lt. oad_lt_ptr) call oad_lt_grow()
      oad_lt(oad_lt_ptr)=x; oad_lt_ptr=oad_lt_ptr+1
      end subroutine 

      subroutine pop_b(x)
C $OpenAD$ INLINE DECLS
      use OAD_tape
      implicit none
      logical :: x
C $OpenAD$ END DECLS
      oad_lt_ptr=oad_lt_ptr-1
      x=oad_lt(oad_lt_ptr)
      end subroutine

      subroutine push_s(s)
C $OpenAD$ INLINE DECLS
      use OAD_tape
      implicit none
      character*(80) :: s
C $OpenAD$ END DECLS
      if(oad_st_sz .lt. oad_st_ptr) call oad_st_grow()
      oad_st(oad_st_ptr)=s; oad_st_ptr=oad_st_ptr+1
      end subroutine 

      subroutine pop_s(s)
C $OpenAD$ INLINE DECLS
      use OAD_tape
      implicit none
      character*(80) :: s
C $OpenAD$ END DECLS
      oad_st_ptr=oad_st_ptr-1
      s=oad_st(oad_st_ptr)
      end subroutine

C ----------------------- Propagation -----------------------

      subroutine saxpy(a,x,y)
C $OpenAD$ INLINE DECLS
      use OAD_active
      double precision, intent(in) :: a
      type(active), intent(in) :: x
      type(active), intent(inout) :: y
C $OpenAD$ END DECLS
      y%d=y%d+x%d*(a)
      end subroutine

      subroutine zeroderiv(x)
C $OpenAD$ INLINE DECLS
      use OAD_active
      type(active), intent(out) :: x
C $OpenAD$ END DECLS
      x%d=0.0d0
      end subroutine

      subroutine setderiv(y,x)
C $OpenAD$ INLINE DECLS
      use OAD_active
      type(active), intent(out) :: x
      type(active), intent(in) :: y
C $OpenAD$ END DECLS
      x%d=y%d
      end subroutine

      subroutine incderiv(y,x)
C $OpenAD$ INLINE DECLS
      use OAD_active
      type(active), intent(out) :: x
      type(active), intent(in) :: y
C $OpenAD$ END DECLS
      x%d=x%d+y%d
      end subroutine

      subroutine decderiv(y,x)
C $OpenAD$ INLINE DECLS
      use OAD_active
      type(active), intent(out) :: x
      type(active), intent(in) :: y
C $OpenAD$ END DECLS
      x%d = x%d - y%d
      end subroutine decderiv

C Checkpointing stuff ---------------------------------------

C reals -----------------------------------------------------
      subroutine cp_arg_store_real_scalar(x)
C $OpenAD$ INLINE DECLS
      use OAD_cp
      double precision :: x
C $OpenAD$ END DECLS
	write(unit=cp_io_unit) x
      end subroutine 

      subroutine cp_arg_restore_real_scalar(x)
C $OpenAD$ INLINE DECLS
      use OAD_cp
      implicit none
      double precision :: x
C $OpenAD$ END DECLS
	read(unit=cp_io_unit) x
      end subroutine 

      subroutine cp_arg_store_real_scalar_a(x)
C $OpenAD$ INLINE DECLS
      use OAD_active
      use OAD_cp
      implicit none
      type(active) :: x
C $OpenAD$ END DECLS
	write(unit=cp_io_unit) x%v
      end subroutine 

      subroutine cp_arg_restore_real_scalar_a(x)
C $OpenAD$ INLINE DECLS
      use OAD_active
      use OAD_cp
      implicit none
      type(active) :: x
C $OpenAD$ END DECLS
      	read(unit=cp_io_unit) x%v
      end subroutine 
      
      subroutine cp_arg_store_real_vector(x)
C $OpenAD$ INLINE DECLS
      use OAD_cp
      implicit none
      double precision, dimension(:) :: x
C $OpenAD$ END DECLS
	write(unit=cp_io_unit) x
      end subroutine 

      subroutine cp_arg_restore_real_vector(x)
C $OpenAD$ INLINE DECLS
      use OAD_cp
      implicit none
      double precision, dimension(:) :: x
C $OpenAD$ END DECLS
      	read(unit=cp_io_unit) x
      end subroutine 

      subroutine cp_arg_store_real_vector_a(x)
C $OpenAD$ INLINE DECLS
      use OAD_active
      use OAD_cp
      implicit none
      type(active), dimension(:) :: x
C $OpenAD$ END DECLS
	write(unit=cp_io_unit) x%v
      end subroutine 

      subroutine cp_arg_restore_real_vector_a(x)
C $OpenAD$ INLINE DECLS
      use OAD_active
      use OAD_cp
      implicit none
      type(active), dimension(:) :: x
C $OpenAD$ END DECLS
      	read(unit=cp_io_unit) x%v
      end subroutine 

      subroutine cp_arg_store_real_matrix(x)
C $OpenAD$ INLINE DECLS
      use OAD_cp
      implicit none
      double precision, dimension(:,:) :: x
C $OpenAD$ END DECLS
	write(unit=cp_io_unit) x
      end subroutine 

      subroutine cp_arg_restore_real_matrix(x)
C $OpenAD$ INLINE DECLS
      use OAD_cp
      implicit none
      double precision, dimension(:,:) :: x
C $OpenAD$ END DECLS
        read(unit=cp_io_unit) x
      end subroutine 

      subroutine cp_arg_store_real_matrix_a(x)
C $OpenAD$ INLINE DECLS
      use OAD_active
      use OAD_cp
      implicit none
      type(active), dimension(:,:) :: x
C $OpenAD$ END DECLS
	write(unit=cp_io_unit) x%v
      end subroutine 

      subroutine cp_arg_restore_real_matrix_a(x)
C $OpenAD$ INLINE DECLS
      use OAD_active
      use OAD_cp
      implicit none
      type(active), dimension(:,:) :: x
C $OpenAD$ END DECLS
      	read(unit=cp_io_unit) x%v
      end subroutine 

      subroutine cp_arg_store_real_three_tensor(x)
C $OpenAD$ INLINE DECLS
      use OAD_cp
      implicit none
      double precision, dimension(:,:,:) :: x
C $OpenAD$ END DECLS
	write(unit=cp_io_unit) x
      end subroutine 

      subroutine cp_arg_restore_real_three_tensor(x)
C $OpenAD$ INLINE DECLS
      use OAD_cp
      implicit none
      double precision, dimension(:,:,:) :: x
C $OpenAD$ END DECLS
      	read(unit=cp_io_unit) x
      end subroutine 

      subroutine cp_arg_store_real_three_tensor_a(x)
C $OpenAD$ INLINE DECLS
      use OAD_active
      use OAD_cp
      implicit none
      type(active), dimension(:,:,:) :: x
C $OpenAD$ END DECLS
	write(unit=cp_io_unit) x%v
      end subroutine 

      subroutine cp_arg_restore_real_three_tensor_a(x)
C $OpenAD$ INLINE DECLS
      use OAD_active
      use OAD_cp
      implicit none
      type(active), dimension(:,:,:) :: x
C $OpenAD$ END DECLS
      	read(unit=cp_io_unit) x%v
      end subroutine 

      subroutine cp_arg_store_real_four_tensor(x)
C $OpenAD$ INLINE DECLS
      use OAD_cp
      implicit none
      double precision, dimension(:,:,:,:) :: x
C $OpenAD$ END DECLS
	write(unit=cp_io_unit) x
      end subroutine 

      subroutine cp_arg_restore_real_four_tensor(x)
C $OpenAD$ INLINE DECLS
      use OAD_cp
      implicit none
      double precision, dimension(:,:,:,:) :: x
C $OpenAD$ END DECLS
	read(unit=cp_io_unit) x
      end subroutine 

      subroutine cp_arg_store_real_four_tensor_a(x)
C $OpenAD$ INLINE DECLS
      use OAD_active
      use OAD_cp
      implicit none
      type(active), dimension(:,:,:,:) :: x
C $OpenAD$ END DECLS
	write(unit=cp_io_unit) x%v
      end subroutine 

      subroutine cp_arg_restore_real_four_tensor_a(x)
C $OpenAD$ INLINE DECLS
      use OAD_active
      use OAD_cp
      implicit none
      type(active), dimension(:,:,:,:) :: x
C $OpenAD$ END DECLS
	read(unit=cp_io_unit) x%v
      end subroutine 

      subroutine cp_arg_store_real_five_tensor(x)
C $OpenAD$ INLINE DECLS
      use OAD_cp
      implicit none
      double precision, dimension(:,:,:,:,:) :: x
C $OpenAD$ END DECLS
	write(unit=cp_io_unit) x
      end subroutine 

      subroutine cp_arg_restore_real_five_tensor(x)
C $OpenAD$ INLINE DECLS
      use OAD_cp
      implicit none
      double precision, dimension(:,:,:,:,:) :: x
C $OpenAD$ END DECLS
	read(unit=cp_io_unit) x
      end subroutine 

      subroutine cp_arg_store_real_five_tensor_a(x)
C $OpenAD$ INLINE DECLS
      use OAD_active
      use OAD_cp
      implicit none
      type(active), dimension(:,:,:,:,:) :: x
C $OpenAD$ END DECLS
	write(unit=cp_io_unit) x%v
      end subroutine 

      subroutine cp_arg_restore_real_five_tensor_a(x)
C $OpenAD$ INLINE DECLS
      use OAD_active
      use OAD_cp
      implicit none
      type(active), dimension(:,:,:,:,:) :: x
C $OpenAD$ END DECLS
	read(unit=cp_io_unit) x%v
      end subroutine 


C integers -----------------------------------------------------
      subroutine cp_arg_store_integer_scalar(x)
C $OpenAD$ INLINE DECLS
      use OAD_cp
      implicit none
      integer :: x
C $OpenAD$ END DECLS
	write(unit=cp_io_unit) x
      end subroutine 

      subroutine cp_arg_restore_integer_scalar(x)
C $OpenAD$ INLINE DECLS
      use OAD_cp
      implicit none
      integer :: x
C $OpenAD$ END DECLS
	read(unit=cp_io_unit) x
      end subroutine 

      subroutine cp_arg_store_integer_vector(x)
C $OpenAD$ INLINE DECLS
      use OAD_cp
      implicit none
      integer, dimension(:) :: x
C $OpenAD$ END DECLS
	write(unit=cp_io_unit) x
      end subroutine 

      subroutine cp_arg_restore_integer_vector(x)
C $OpenAD$ INLINE DECLS
      use OAD_cp
      implicit none
      integer, dimension(:) :: x
C $OpenAD$ END DECLS
	read(unit=cp_io_unit) x
      end subroutine 

      subroutine cp_arg_store_integer_matrix(x)
C $OpenAD$ INLINE DECLS
      use OAD_cp
      implicit none
      integer, dimension(:,:) :: x
C $OpenAD$ END DECLS
	write(unit=cp_io_unit) x
      end subroutine 

      subroutine cp_arg_restore_integer_matrix(x)
C $OpenAD$ INLINE DECLS
      use OAD_cp
      implicit none
      integer, dimension(:,:) :: x
C $OpenAD$ END DECLS
	read(unit=cp_io_unit) x
      end subroutine 

      subroutine cp_arg_store_integer_three_tensor(x)
C $OpenAD$ INLINE DECLS
      use OAD_cp
      implicit none
      integer, dimension(:,:,:) :: x
C $OpenAD$ END DECLS
	write(unit=cp_io_unit) x
      end subroutine 

      subroutine cp_arg_restore_integer_three_tensor(x)
C $OpenAD$ INLINE DECLS
      use OAD_cp
      implicit none
      integer, dimension(:,:,:) :: x
C $OpenAD$ END DECLS
        read(unit=cp_io_unit) x
      end subroutine 

      subroutine cp_arg_store_integer_four_tensor(x)
C $OpenAD$ INLINE DECLS
      use OAD_cp
      implicit none
      integer, dimension(:,:,:,:) :: x
C $OpenAD$ END DECLS
        write(unit=cp_io_unit) x
      end subroutine 

      subroutine cp_arg_restore_integer_four_tensor(x)
C $OpenAD$ INLINE DECLS
      use OAD_cp
      implicit none
      integer, dimension(:,:,:,:) :: x
C $OpenAD$ END DECLS
        read(unit=cp_io_unit) x
      end subroutine 

      subroutine cp_arg_store_integer_five_tensor(x)
C $OpenAD$ INLINE DECLS
      use OAD_cp
      implicit none
      integer, dimension(:,:,:,:,:) :: x
C $OpenAD$ END DECLS
        write(unit=cp_io_unit) x
      end subroutine 

      subroutine cp_arg_restore_integer_five_tensor(x)
C $OpenAD$ INLINE DECLS
      use OAD_cp
      implicit none
      integer, dimension(:,:,:,:,:) :: x
C $OpenAD$ END DECLS
        read (unit=cp_io_unit) x
      end subroutine 

C strings  -----------------------------------------------------
      subroutine cp_arg_store_string_scalar(x)
C $OpenAD$ INLINE DECLS
      use OAD_cp
      implicit none
      character*(80) :: x
C $OpenAD$ END DECLS 
        write(unit=cp_io_unit) x
      end subroutine 
      
      subroutine cp_arg_restore_string_scalar(x)
C $OpenAD$ INLINE DECLS
      use OAD_cp
      implicit none
      character*(80) :: x
C $OpenAD$ END DECLS
        read (unit=cp_io_unit) x
      end subroutine 

C bools  -----------------------------------------------------
      subroutine cp_arg_store_bool_scalar(x)
C $OpenAD$ INLINE DECLS
      use OAD_cp
      implicit none
      logical :: x
C $OpenAD$ END DECLS
        write(unit=cp_io_unit) x
      end subroutine 

      subroutine cp_arg_restore_bool_scalar(x)
C $OpenAD$ INLINE DECLS
      use OAD_cp
      implicit none
      logical :: x
C $OpenAD$ END DECLS
        read (unit=cp_io_unit) x
      end subroutine 

      subroutine cp_arg_store_bool_matrix(x)
C $OpenAD$ INLINE DECLS
      use OAD_cp
      implicit none
      logical, dimension(:,:) :: x
C $OpenAD$ END DECLS
	write(unit=cp_io_unit) x
      end subroutine 

      subroutine cp_arg_restore_bool_matrix(x)
C $OpenAD$ INLINE DECLS
      use OAD_cp
      implicit none
      logical, dimension(:,:) :: x
C $OpenAD$ END DECLS
	read(unit=cp_io_unit) x
      end subroutine 
