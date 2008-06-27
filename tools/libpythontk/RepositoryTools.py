#!usr/bin/env python
import os
import sys
import RunCmds
from RunCmds import CmdDesc

class RepositoryDesc:

  def __init__(self):
    self.name ="none"  # name
    self.path="none"    # path to repository
    self.subdir="none"  # subdirectory of repository (optional)
    self.repos="none"   # if undef, considered 'external'; user must manage
    self.tag="none"     # interpreted as a tag/branch by default;
    self.var="none"     # corresponding environment variable

  def setName(self, name):
    self.name = name
  def setPath(self, path):
    self.path = path
  def setSubdir(self, subdir):
    self.subdir=subdir
  def setRepos(self, repos):
    self.repos=repos
  def setTag(self, tag):
    self.tag=tag
  def setVar(self, var):
    self.var=var
  def setAll(self, name, path, subdir, repos, tag, var):
    self.setName(name)
    self.setPath(path)
    self.setSubdir(subdir)
    self.setRepos(repos)
    self.setTag(tag)
    self.setVar(var)
  def getName(self):
    return self.name
  def getPath(self):
    return self.path
  def getSubdir(self):
    return self.subdir
  def getRepos(self):
    return self.repos
  def getTag(self):
    return self.tag
  def getVar(self):
    return self.var

class CVSReposDesc:
  def __init__(self):
    self.iscvs = 1
    self.rsh = "none"
    self.root = "none"

  def set_iscvs(self, iscvs):
    self.iscvs = iscvs
  def set_rsh(self, rsh):
    self.rsh = rsh
  def set_root(self, root):
    self.root = root
  def get_iscvs(self):
    return self.iscvs
  def get_rsh(self):
    return self.rsh
  def get_root(self):
    return self.root

class BKReposDesc:
  def __init__(self):
    self.isbk=1
    self.root = "none"

  def set_isbk(self, isbk):
    self.isbk = isbk
  def set_root(self, root):
    self.root = root
  def get_isbk(self):
    return self.isbk
  def get_root(self):
    return self.root

#############################################################################

# RunRepositoryUpdate: Given several arguments, perform a get or
# update on a repository that itself contains other cvs or bitkeeper
# repositories.
#   selfRoot     - the root of the shell CVS repository
#   selfCVSFiles - list of shell globs representing the shell CVS repository
#   repositories - list of 'RepositoryDesc'
#   opts         - a hash of options
#     'skipupdate'  - do not update an existing repository (boolean)
#     'interactive' - run commands interactively (boolean)
#     'verbose'     - 0 (no), 1 (moderate) or 2 (extreme)
#     'logfnm'      - if defined, the name of a log file to which all output
#                     should be sent
#     'debug'       - if defined, a debug level from 0 - 9


class RepositoryTools:

  def __init__(self):
    None

  def RunRepositoryUpdate(self, selfRoot, selfCVSFiles, repositories, opts):
    cmdDescVecRef = []
    desc = 'undef'
    optsKeys = {'skipupdate': 'undef',
                'interactive':'undef',
                'verbose':'undef',
                'debug':'undef'}
    for k,val in optsKeys.items():
      if opts[k] != 0 and opts[k] != 'undef':
        val = opts[k]
      else:
        val = 0

  # --------------------------------------------------------
  # Generate commands for self (always a cvs update)
  # --------------------------------------------------------

    selfFiles = ''    
    for file in selfCVSFiles:
      selfFiles += ' '+file

    desc = CmdDesc()
    env = 'CVS_RSH="' + selfRoot+'/tools/sshcvs/sshcvs-hipersoft-anon"'
    command='cd '+selfRoot+' && '+env+' cvs update '+selfFiles
    desc.setCmd(command)
    description = desc.getCmd()
    desc.setDesc(description)
    cmdDescVecRef.append(desc)

  # --------------------------------------------------------
  # Generate commands for sub repositories
  # --------------------------------------------------------

    for repo in repositories.values():
       # if we don't have repository info, then this is external to us
      if repo.getRepos() is "none":
        continue
      localRepoPath = os.path.join(repo.getPath(),repo.getName())
      if repo.getSubdir() is not "none":
        localRepoPath = os.path.join(localRepoPath,repo.getSubdir())
      repoExists = "-d "+localRepoPath
      if repo.getTag is not "none":
        repoTag = repo.getTag()
      else:
        repoTag = "default"

      if (repoExists and optsKeys['skipupdate']):
        continue
      
      # Either checkout or update the repository
      desc = RunCmds.CmdDesc
      
      if (repo.getRepos() is not "none") \
         and repo.getRepos().get_iscvs():
        # A CVS repository
        nm = repo.getName()
        env = 'CVS_RSH="' + repo.getRepos().get_rsh() + '"'
        opt = '-z5 -d ' + repo.getRepos().get_root()
        tag = repoTag

        if repoExists:
          desc.setCmd("cd "+localRepoPath+" && "+env+" cvs "+opt+" update -d")
        else:
          if repo.getSubdir is not "none":
            nm = os.path.join(nm,repo.getSubdir())
          topt = getCVSTagOpt(repo.getTag())
          desc.setCmd("cd "+repo.getPath()+" && "+env+" cvs "+opt+" co "+topt+" "+nm)
        desc.setDesc(desc.getCmd())
      elif repo.getRepos() is not "none" \
        and repo.getRepos().get_isbk() is not "none":
        # A BitKeeper repository
        nm = repo.getName()
        arg = repo.getRepos().get_root()
        tag = repoTag

        if repoExists:
          desc.setCmd("cd "+repo.getPath()+" && update "+arg+" "+nm)
          desc.setDesc("update "+arg+" "+nm)
        else:
          desc.setCmd("cd "+repo.getPath()+" && sfioball "+arg+" "+nm)
          desc.setDesc("sfioball "+arg+" "+nm)
      else:
        sys.stderr.write("Programming Error!")
        sys.exit()
      cmdDescVecRef.append(desc)

  # --------------------------------------------------------
  # Run commands
  # --------------------------------------------------------
    if opts['debug'] != "unknown":
      sys.stdout.write("--> "+opts['logfnm']+"\n")
    RunCmds.RunCmds().RunCmds(cmdDescVecRef, opts['verbose'], opts['interactive'], opts['logfnm'])

# getCVSTagOpt: 
  def getCVSTagOpt(self, tag):
    opt=""
    if tag:
      date = ""
      re = '^{date}(.*)'
      if ((date) == tag.find('/'+re+'/')): 
        opt = '-D '+date
      else:
        opt = "-r "+tag
    return opt


############################################################################
