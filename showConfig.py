#!/usr/bin/python

import os
import sys
import re
from optparse import OptionParser

def repKind(rep):
    matches=0
    returnVal=''
    if (os.path.isdir('./'+rep+'/CVS')):
        matches+=1
        returnVal='cvs'
    if (os.path.isdir('./'+rep+'/.hg')):   
        matches+=1
        returnVal='hg'
    if (os.path.isdir('./'+rep+'/.svn')):   
        matches+=1
        returnVal='svn'
    if (matches>1):
        raise RuntimeError, "more than one possible repository type for "+rep   
    if (matches<1):
        raise RuntimeError, "cannot find repository type for "+rep   
    return returnVal

def cvsParent(rep):
    rootFile=open('CVS/Root')
    rootString=rootFile.readline()
    rootFile.close()
    return rootString

def svnParent(rep):
    system('svn info > svn.info')
    infoFile=open('svn.info')
    infoString=''
    while 1:
        infoString=infoFile.readline()
        if (infoString[:5]=='URL: ' or len(infoString)==0):
            break
    infoFile.close()
    if (infoString[:5]!='URL: '): 
        raise RuntimeError, "cannot find url for "+rep   
    return infoString[5:]

def hgParent(rep):
    os.system('hg show > hg.info')
    infoFile=open('hg.info')
    infoString=''
    headAttribute='paths.default='
    while 1:
        infoString=infoFile.readline()
        if (infoString[:len(headAttribute)]==headAttribute or len(infoString)==0):
            break
    infoFile.close()
    if (infoString[:len(headAttribute)]!=headAttribute):
        raise RuntimeError, "cannot find url for "+rep   
    return infoString[len(headAttribute):]

def main():
  usage = '%prog [options]'
  opt = OptionParser(usage=usage)
  opt.add_option('-q','--quick',dest='quick',
                 help="don't check for uncommited changes or pending pushes",
                 action='store_true',default=False)
  (options, args) = opt.parse_args()
  cwd=os.getcwd()
  if (os.path.basename(cwd) != 'OpenAD'):
      print 'the current working directory has to the the OpenAD root directory'
      return -1
  repList=['../OpenAD','angel','boost','Open64','OpenADFortTk','OpenAnalysis','xaif','xaifBooster','xercesc']
  maxNameLength=max([len(r) for r in repList])
  repDict={}
  repDict['cvs']=cvsParent
  repDict['svn']=svnParent
  repDict['hg']=hgParent
  try:
      for i in repList:
          repK=repKind(i)
          os.chdir(i)
          info=repDict[repK](i)
          os.chdir(cwd)
          patchedName=i+"".join([' ' for s in range(len(i),maxNameLength)])
          sys.stdout.write('%s\t%s\t' % (patchedName,repK))
          if (re.search('anon',info) is None):
              sys.stdout.write('W')
          else:
              sys.stdout.write('R')
          sys.stdout.write('\t%s\n' % info.strip())
  except RuntimeError, e:
      print 'caught excetion: ',e
      return -1

if __name__ == "__main__":
  sys.exit(main())
