ifndef FC    
FC  = gfortran
endif
FFLAGS   = -g -O0
MODS = w2f__types OADactive OADtape OADrev
TARGETS=driver driverFd driverAdm

all: $(TARGETS)

driver: driver.o compute.o init.o
	$(FC) -o $@ $^ $(LDFLAGS) $(LIBS)

driverFd: driverFd.o compute.o init.o
	$(FC) -o $@ $^ $(LDFLAGS) $(LIBS)

%.o : %.f90
	$(FC) $(FFLAGS) -c $<

driverAdm: $(addsuffix .o, $(MODS)) driverAdm.o compute.xb.x2w.w2f.pp.o init.o
	$(FC) -o $@ $^ $(LDFLAGS) $(LIBS)

# F -> WHIRL
compute.B: compute.f90
	${OPEN64ROOT}/crayf90/sgi/mfef90 -DOAD_TRANS -z -I$(MPIROOT)/include -F -N132 $<

# WHIRL -> XAIF
compute.xaif : compute.B 
	${OPENADFORTTKROOT}/bin/whirl2xaif -o $@ $<

# XAIF -> XAIF'
compute.xb.xaif : compute.xaif
	${XAIFBOOSTERROOT}/xaifBooster/algorithms/BasicBlockPreaccumulationReverse/test/t -i $< -c ${XAIFSCHEMAROOT}/schema/examples/inlinable_intrinsics.xaif -s ${XAIFSCHEMAROOT}/schema -o $@ -U

# XAIF' -> WHIRL'
compute.xb.x2w.B : compute.xb.xaif  
	${OPENADFORTTKROOT}/bin/xaif2whirl --structured compute.B $<

# WHIRL' -> F'
compute.xb.x2w.w2f.f: compute.xb.x2w.B
	${OPEN64ROOT}/whirl2f/whirl2f -openad $<

# postprocess F'
compute.xb.x2w.w2f.pp.f: compute.xb.x2w.w2f.f ../oad_t_split.f
	perl ${OPENADFORTTKROOT}/bin/multi-pp.pl -i ../ad_inline.f $<

w2f__types.f90 OADactive.f90 OADtape.f90 OADrev.f90 : 
	ln -sf ../$@ $@

clean:
	rm -f $(TARGETS) *.o compute.x* compute.B *.mod *.mod-whirl
	rm -f $(addsuffix .o, $(MODS)) $(addsuffix .f90, $(MODS))
