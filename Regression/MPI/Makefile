MPICHDIR = ../..
FC       = $(MPIROOT)/bin/mpif90
FFLAGS   = -g -O0
SOURCES  = $(wildcard *.f90)
OBJ      = $(SOURCES:.f90=.o)

driver: $(OBJ)
	$(FC) -o $@ $^ $(LDFLAGS) $(LIBS)

%.o : %.f90
	$(FC) $(FFLAGS) -c $<

clean:
	rm -f $(OBJ) driver
