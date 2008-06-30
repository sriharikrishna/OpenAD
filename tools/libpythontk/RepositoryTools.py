#!usr/bin/env python
import os
import sys
import RunCmds
import Repository
from RunCmds import CmdDesc

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
    desc.setDesc(command)
    cmdDescVecRef.append(desc)

  # --------------------------------------------------------
  # Generate commands for sub repositories
  # --------------------------------------------------------

    for repo in repositories.values():
       # if we don't have repository info, then this is external to us
      if repo.getType() is "none":
        continue
      if (repo.repoExists() and optsKeys['skipupdate']):
        continue
      # Either checkout or update the repository
      if repo.getType() == "cvs":
        # A CVS repository
        if repoExists:
          repo.setCmdDesc() # sets CmdDesc to update repository
        else:
          if repo.getSubdir is not "none":
            repo.setCmdDescSubdir() # sets CmdDesc to update subdir repository
      else:
        sys.stderr.write("Programming Error!")
        sys.exit()
      cmdDescVecRef.append(repo.CmdDesc.getDesc())

  # --------------------------------------------------------
  # Run commands
  # --------------------------------------------------------
    if opts['debug'] != "unknown":
      sys.stdout.write("--> "+opts['logfnm']+"\n")
    RunCmds.RunCmds().RunCmds(cmdDescVecRef, opts['verbose'], opts['interactive'], opts['logfnm'])

############################################################################
