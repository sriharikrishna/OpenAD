#!/usr/bin/env python

import os
import sys
import subprocess
import string

#############################################################################
##
## OpenAD configuration information for subpackages.
##
## This is a Python module masquerading as a configuration file.
## Figuring this out should be pretty easy, but if you are making
## changes to the defaults, we presume you know what you are doing or
## can handle the consequences.
##
##############################################################################
#Get path of file's directory (it should be called from the directory it's in)
OpenADRoot=os.path.dirname(__file__)
#Calling script should be located in OpenAD root directory
libpythontk = os.path.join(OpenADRoot, 'tools/libpythontk')
sys.path.append(libpythontk)
import RunCmds
from RepositoryTools import RepositoryDesc, CVSReposDesc

#############################################################################
## Subpackage configuration information
#############################################################################

######################################################################
# Repository information
######################################################################

# USER is not available in some Cygwin environments
try:
  defaultUser = os.environ['USER']
except NameError, e:
  print e
  defaultUser = os.environ['USERNAME']

##################################################
# Rice HiPerSoft CVS Repository
##################################################

riceUser = 'anoncvs'

OPENAD_REPO_RICECVS = CVSReposDesc()
OPENAD_REPO_RICECVS.set_rsh(os.path.join(OpenADRoot,"tools/sshcvs/sshcvs-hipersoft-anon"))
OPENAD_REPO_RICECVS.set_root(':ext:'+riceUser+'@koolkat2.cs.rice.edu:/Volumes/cvsrep/developer')

##################################################
# SourceForge CVS Repositories
##################################################
OPENAD_REPO_SF_ANGEL = CVSReposDesc()
OPENAD_REPO_SF_ANGEL.set_rsh('pserver')
OPENAD_REPO_SF_ANGEL.set_root(':pserver:anonymous@boost.cvs.sourceforge.net:/cvsroot/boost')

OPENAD_REPO_SF_BOOST = CVSReposDesc()
OPENAD_REPO_SF_BOOST.set_rsh( 'pserver')
OPENAD_REPO_SF_BOOST.set_root(':pserver:anonymous@boost.cvs.sourceforge.net:/cvsroot/boost')

######################################################################
# OpenAD Repositories, Local Instances
###################################################################### 

#############################################################################
## Methods
#############################################################################
class openad_config:

# A list of all repositories (RepositoryDesc) in this configuation of OpenAD
  """def __init__(self):
    self.OpenADRepos= [OPENAD_OPEN64,OPENAD_OPENADFORTTK,OPENAD_OPENANALYSIS,OPENAD_XERCESC,OPENAD_XAIFBOOSTER,OPENAD_ANGEL,OPENAD_XAIF,OPENAD_BOOST]"""

  def __init__(self):
    platformToOpen64TargTable = {'alpha-OSFI': 'targ_alpha_tru64',
                                 'x86-Linux': 'targ_ia32_ia64_linux',
                                 'x86_64-Linux': 'targ_ia64_ia64_linux',
                                 'x86-Cygwin': 'targ_ia32_ia64_linux',
                                 'ia64-Linux': 'targ_ia64_ia64_linux',
                                 'mips-IRIX64': 'targ_mips_irix',
                                 'sparc-SunOS': 'targ_sparc_solaris'}
    
    #Generate canonical platform
    get_platform = 'cd '+OpenADRoot+'/config && ./hpcplatform'
    p = subprocess.Popen(get_platform, shell=True,stdout=subprocess.PIPE)
    platform=(p.stdout.read()).rstrip()
    o64targ = platformToOpen64TargTable[platform]
    os.environ['o64targ']=o64targ
    os.environ['platform']=platform

    self.OPENAD_OPEN64 = RepositoryDesc()
    self.OPENAD_OPENADFORTTK = RepositoryDesc()
    self.OPENAD_OPENANALYSIS = RepositoryDesc()
    self.OPENAD_XERCESC = RepositoryDesc()
    self.OPENAD_XAIFBOOSTER = RepositoryDesc()
    self.OPENAD_ANGEL = RepositoryDesc()
    self.OPENAD_XAIF = RepositoryDesc()
    self.OPENAD_BOOST = RepositoryDesc()
    self.OpenADRepos = {"OPENAD_OPEN64":self.OPENAD_OPEN64,
                        "OPENAD_OPENADFORTTK":self.OPENAD_OPENADFORTTK,
                        "OPENAD_OPENANALYSIS":self.OPENAD_OPENANALYSIS,
                        "OPENAD_XERCESC":self.OPENAD_XERCESC,
                        "OPENAD_XAIFBOOSTER":self.OPENAD_XAIFBOOSTER,
                        "OPENAD_ANGEL":self.OPENAD_ANGEL,
                        "OPENAD_XAIF":self.OPENAD_XAIF,
                        "OPENAD_BOOST":self.OPENAD_BOOST}
######################################################################
# set OpenAD Repositories
###################################################################### 

    self.OPENAD_OPEN64.setAll('Open64',OpenADRoot,"none",OPENAD_REPO_RICECVS,"OpenAD","OPEN64_BASE")
    self.OPENAD_OPENADFORTTK.setAll('OpenADFortTk',OpenADRoot,"none",OPENAD_REPO_RICECVS,"none",'OPENADFORTTK_BASE')
    self.OPENAD_OPENANALYSIS.setAll('OpenAnalysis',OpenADRoot,"none",OPENAD_REPO_RICECVS,"none",'OPENANALYSIS_BASE')
    self.OPENAD_XERCESC.setAll('xercesc', OpenADRoot,"none",OPENAD_REPO_RICECVS,"none",'XERCESC_BASE')
    self.OPENAD_XAIFBOOSTER.setAll('xaifBooster',OpenADRoot,"none",OPENAD_REPO_RICECVS,"none",'XAIFBOOSTER_BASE')
    self.OPENAD_ANGEL.setAll('angel',OpenADRoot,"none",OPENAD_REPO_SF_ANGEL,"none",'ANGEL_BASE')
    self.OPENAD_XAIF.setAll('xaif',OpenADRoot,"none",OPENAD_REPO_RICECVS,"none",'XAIFSCHEMA_BASE')
    self.OPENAD_BOOST.setAll('boost',OpenADRoot,"boost",OPENAD_REPO_SF_BOOST,'Version_1_34_1','BOOST_BASE')
######################################################################
# set OpenAD Environment Variables
######################################################################
    self.setPythonOpenADEnvVars()
    
######################################################################
# define RootEnvVars
######################################################################
    self.RootEnvVars = {'OPEN64ROOT':os.path.join(os.environ['OPEN64_BASE'],'osprey1.0',o64targ),
       'OPENADFORTTKROOT':os.path.join(os.environ['OPENADFORTTK_BASE'],'OpenADFortTk-'+platform),
       'OPENANALYSISROOT':os.path.join(os.environ['OPENANALYSIS_BASE'],platform),
       'XERCESCROOT':os.path.join(os.environ['XERCESC_BASE'],platform),
       'XAIFBOOSTERROOT':os.path.join(os.environ['XAIFBOOSTER_BASE'],'..'),
       'BOOSTROOT':os.environ['BOOST_BASE'],
       'ANGELROOT':os.environ['ANGEL_BASE'],
       'XAIFSCHEMAROOT':os.environ['XAIFSCHEMA_BASE'],
       'OPENADFORTTK':os.path.join(os.environ['OPENADFORTTK_BASE'],'OpenADFortTk-'+platform)}

######################################################################
# set RootEnvVars
######################################################################
    self.setPythonRootEnvVars()

######################################################################
# define Aliases
######################################################################
    xbase=os.path.join(os.environ['XAIFBOOSTERROOT'],'xaifBooster')
    ii_xaif=os.path.join(os.environ['XAIFSCHEMAROOT'],'schema/examples/inlinable_intrinsics.xaif')
    if (os.environ['platform'] is 'i686-Cygwin'):
      ii_xaif = '\`cygpath -w ${ii_xaif}\`'
    self.Aliases = {
       'mfef90':os.path.join(os.environ['OPEN64ROOT'],'/crayf90/sgi/mfef90'),
       'whirl2f':os.path.join(os.environ['OPEN64ROOT'],'/whirl2f/whirl2f'),
       'whirl2f90':os.path.join(os.environ['OPEN64ROOT'],'/whirl2f/whirl2f90'),
       'ir_b2a':os.path.join(os.environ['OPEN64ROOT'],'/ir_tools/ir_b2a'),
       'ir_size':os.path.join(os.environ['OPEN64ROOT'],'/ir_tools/ir_size'),
       'xboostread':xbase+'/system/test/t -c '+ii_xaif,
       'xboost_l':xbase+'/algorithms/Linearization/test/t -c '+ii_xaif,
       'xboost_bb':xbase+'/algorithms/BasicBlockPreaccumulation/test/t -c '+ii_xaif,
       'xboost_bbt':xbase+'/algorithms/BasicBlockPreaccumulationTape/test/t -c '+ii_xaif,
       'xboost_bbr':xbase+'/algorithms/BasicBlockPreaccumulationReverse/test/t -c '+ii_xaif,
       'xboost_cfr':xbase+'/algorithms/ControlFlowReversal/test/t -c '+ii_xaif}


# set OpenAD environment variables in python environment (called in __init__)
  def setPythonOpenADEnvVars(self):
    for repo in self.OpenADRepos.values():
      os.environ[repo.getVar()] = os.path.abspath(os.path.join(repo.getPath(), repo.getName()))
    os.environ['OPENAD_BASE'] = OpenADRoot
  
# set Root environment variables in python environment (called in __init__)
  def setPythonRootEnvVars(self):
    for var,val in self.RootEnvVars.items():
      os.environ[var] = os.path.abspath(val)
    os.environ['OPENADROOT'] = os.environ['OPENAD_BASE']

# set paths for python environment
  def setPaths(self):
    sys.path.append(os.path.join(os.environ['OPENADFORTTK'],'bin'))
    sys.path.append(os.path.join(os.environ['OPENADROOT'],'bin'))
    if(os.environ['platform'] is 'i686-Cygwin'):
      path = os.path.join(os.environ['XERCESCROOT'],'bin:',os.environ['XERCESCROOT'],'lib:',os.environ['OPEN64ROOT'],'be:',os.environ['OPEN64ROOT'],'whirl2f:',os.environ['PATH'])
      sys.path.append(path)
    else:
      ldlib = os.path.join(os.environ['OPEN64ROOT'],'whirl2f')
      if os.getenv('LD_LIBRARY_PATH') == None:
        os.environ['LD_LIBRARY_PATH'] = ldlib
      else:
        os.environ['LD_LIBRARY_PATH'] = os.getenv('LD_LIBRARY_PATH')+":"+ldlib

# set symlinks for python environment
  def setAliases(self):
    for alias, path in self.Aliases.items():
      os.symlink(path, alias)

    # runtime support
    os.symlink(os.path.join(os.environ['XAIFBOOSTER_BASE'],'testRoundTrip/active_module.f90'),'active_module.f90')
    os.symlink(os.path.join(os.environ['XAIFBOOSTER_BASE'],'w2f__types.f'), 'w2__types.f')


# getRepos: returns an array of 'RepositoryDesc' references
#   containing the repository information
  def getRepos(self):
    return self.OpenADRepos
