# $Header: /Volumes/cvsrep/developer/OpenAD/Makefile,v 1.13 2007/04/11 13:28:12 utke Exp $
# -*-makefile-*-
## * BeginCopyright *********************************************************
## 
## 
## *********************************************************** EndCopyright *

#############################################################################
# $Source: /Volumes/cvsrep/developer/OpenAD/Makefile,v $
#############################################################################

#############################################################################

SHELL = /bin/sh
WD := $(shell pwd)

PLATFORM := $(shell cd $(WD)/config; ./hpcplatform)
ifeq ($(PLATFORM),)
  $(error "Unknown/unsupported platform") # unavailable in older gmakes
  error "Unknown/unsupported platform"    # will certainly cause an error
endif

# xercesc platform
ifeq ($(PLATFORM),x86-Cygwin)
  XERCESPLATFORM = CYGWIN
endif
ifeq ($(PLATFORM),x86-Linux)
  XERCESPLATFORM = LINUX
endif
ifeq ($(PLATFORM),x86_64-Linux)
  XERCESPLATFORM = LINUX
endif
ifeq ($(PLATFORM),ia64-Linux)
  XERCESPLATFORM = LINUX
endif
ifeq ($(PLATFORM),opteron-Linux)
  XERCESPLATFORM = LINUX
endif
ifeq ($(PLATFORM),sparc-SunOS)
  XERCESPLATFORM = SOLARIS
endif
ifndef XERCESPLATFORM
  $(error "Error: XERCESPLATFORM not set!")
endif

#############################################################################

# WARNING: exporting these causes problems with the Open64 build system
#export CC
#export CXX
#export CFLAGS
#export CXXFLAGS

#############################################################################

all: configure build install

.PHONY : all

#############################################################################

configure: 
	@echo "*** Configuring (doing nothing) ***"

build: open64_build oa_build xercesc_build openadforttk_build \
	xaifbooster_build

# clean build files only
clean: open64_clean oa_clean xercesc_clean openadforttk_clean \
	xaifbooster_clean

# clean everything
veryclean: open64_veryclean oa_veryclean xercesc_veryclean \
	openadforttk_veryclean xaifbooster_veryclean

.PHONY : configure build clean

#############################################################################

open64_build:
	@if [ -d $(OPEN64ROOT) ]; then \
	  echo "*** Building Open64 ***" ; \
	  cd $(OPEN64ROOT)/crayf90/sgi && $(MAKE) ; \
	  cd $(OPEN64ROOT)/whirl2f && $(MAKE) ; \
	  cd $(OPEN64ROOT)/ir_tools && $(MAKE) ; \
	else \
	  echo "*** Building Open64 -- NON-EXISTENT ***" ; \
	fi

open64_clean:
	@if [ -d $(OPEN64ROOT) ]; then \
	  echo "*** Cleaning Open64 ***" ; \
	  cd $(OPEN64ROOT) && $(MAKE) clean ; \
	else \
	  echo "*** Cleaning Open64 -- NON-EXISTENT ***" ; \
	fi

open64_veryclean:
	@if [ -d $(OPEN64ROOT) ]; then \
	  echo "*** Very-Cleaning Open64 ***" ; \
	  cd $(OPEN64ROOT) && $(MAKE) clobber ; \
	else \
	  echo "*** Very-Cleaning -- NON-EXISTENT ***" ; \
	fi

.PHONY : open64_build open64_clean open64_veryclean 

############################################################

# FIXME: make a rebuild target for OA and Xercesc Makefiles
# FIXME: reinstalling this stuff will cause exes like xaifbooster to relink!
OA_OPT = -f Makefile.quick CXX="$(CXX)"

oa_build:
	@if [ -d $(OPENANALYSIS_BASE) ]; then \
	  echo "*** Building OA ***" ; \
	  if [ -d $(OPENANALYSIS_BASE)/build-$(PLATFORM) ]; then \
	    cd $(OPENANALYSIS_BASE) && $(MAKE) $(OA_OPT) install ; \
	  else \
	    cd $(OPENANALYSIS_BASE) && $(MAKE) $(OA_OPT) all; \
	  fi \
	else \
	  echo "*** Building OA -- NON-EXISTENT ***" ; \
	fi

oa_clean:
	@if [ -d $(OPENANALYSIS_BASE) ]; then \
	  echo "*** Cleaning OA ***" ; \
	  cd $(OPENANALYSIS_BASE) && $(MAKE) $(OA_OPT) clean ; \
	else \
	  echo "*** Cleaning OA -- NON-EXISTENT ***" ; \
	fi

oa_veryclean: oa_clean

.PHONY : oa_build oa_clean oa_veryclean 

############################################################

XERCESC_OPT = CXX="$(CXX)" CC="$(CC)"

xercesc_build:
	@if [ -d $(XERCESC_BASE) ]; then \
	  echo "*** Building xercesc ***" ; \
	  if [ -d $(XERCESC_BASE)/xerces-c-src_2_6_0/obj/$(XERCESPLATFORM) ]; then \
	    cd $(XERCESC_BASE) && $(MAKE) $(XERCESC_OPT) build install ; \
	  else \
	    cd $(XERCESC_BASE) && $(MAKE) $(XERCESC_OPT) ; \
	  fi \
	else \
	  echo "*** Building xercesc -- NON-EXISTENT ***" ; \
	fi

xercesc_clean:
	@if [ -d $(XERCESC_BASE) ]; then \
	  echo "*** Cleaning xercesc ***" ; \
	  cd $(XERCESC_BASE) && $(MAKE) $(XERCESC_OPT) clean ; \
	else \
	  echo "*** Cleaning xercesc -- NON-EXISTENT ***" ; \
	fi

xercesc_veryclean: xercesc_clean

.PHONY : xercesc_build xercesc_clean xercesc_veryclean 

############################################################

FORTTK_OPT = -f Makefile.quick CXX="$(CXX)" CC="$(CC)" 

openadforttk_build:
	@if [ -d $(OPENADFORTTK_BASE) ]; then \
	  echo "*** Building OpenADFortTk ***" ; \
	  cd $(OPENADFORTTK_BASE) && $(MAKE) $(FORTTK_OPT) all; \
	else \
	  echo "*** Building OpenADFortTk -- NON-EXISTENT ***" ; \
	fi

openadforttk_clean:
	@if [ -d $(OPENADFORTTK_BASE) ]; then \
	  echo "*** Cleaning OpenADFortTk ***" ; \
	  cd $(OPENADFORTTK_BASE) && $(MAKE) $(FORTTK_OPT) clean ; \
	else \
	  echo "*** Cleaning OpenADFortTk -- NON-EXISTENT ***" ; \
	fi

openadforttk_veryclean: openadforttk_clean

.PHONY : openadforttk_build openadforttk_clean openadforttk_veryclean 

############################################################

xaifbooster_build:
	@if [ -d $(XAIFBOOSTER_BASE) -a -d $(ANGEL_BASE) ]; then \
	  echo "*** Building xaifBooster ***" ; \
	  cd $(XAIFBOOSTER_BASE) && $(MAKE) ; \
	  cd $(ANGEL_BASE) && $(MAKE) ; \
	  cd $(XAIFBOOSTER_BASE) && $(MAKE) test ; \
	else \
	  echo "*** Building xaifBooster -- NON-EXISTENT ***" ; \
	fi

xaifbooster_clean:
	@if [ -d $(XAIFBOOSTER_BASE) -a -d $(ANGEL_BASE) ]; then \
	  echo "*** Cleaning xaifBooster (skipping) ***" ; \
	else \
	  echo "*** Cleaning xaifBooster -- NON-EXISTENT ***" ; \
	fi

xaifbooster_veryclean:
	@if [ -d $(XAIFBOOSTER_BASE) -a -d $(ANGEL_BASE) ]; then \
	  echo "*** Very-Cleaning xaifBooster ***" ; \
	  cd $(ANGEL_BASE) && $(MAKE) clean ; \
	  cd $(XAIFBOOSTER_BASE) && $(MAKE) clean ; \
	else \
	  echo "*** Very-Cleaning xaifBooster -- NON-EXISTENT ***" ; \
	fi

.PHONY : xaifbooster_build xaifbooster_clean xaifbooster_veryclean

############################################################

install: uninstall
	@echo "*** Installing (doing nothing) ***"

uninstall: 
	@echo "*** Uninstalling (doing nothing) ***"

.PHONY : install uninstall

#############################################################################

