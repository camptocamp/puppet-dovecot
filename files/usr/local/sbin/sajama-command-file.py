#!/usr/bin/env python
import os, sys, commands

ionice = commands.getstatus('which ionice')
if ionice:
  allowedCmd = {'rdiff':'PYTHONPATH=/opt/rdiff-backup/rdiff-backup-1.2.5/lib64/python2.4/site-packages nice -n 10 /opt/rdiff-backup/rdiff-backup-1.2.5/bin/rdiff-backup --server', 
      'vzlist':'vzlist -H -o veid,hostname', 
      'version':'echo 1.2.5'}
else:
  allowedCmd = {'rdiff':'PYTHONPATH=/opt/rdiff-backup/rdiff-backup-1.2.5/lib64/python2.4/site-packages nice -n 10 ionice -n 7 /opt/rdiff-backup/rdiff-backup-1.2.5/bin/rdiff-backup --server',
      'vzlist':'vzlist -H -o veid,hostname',
      'version':'echo 1.2.5'}

default = allowedCmd['rdiff']

sshOrig = os.getenv('SSH_ORIGINAL_COMMAND')
cmd = ''

if sshOrig:
  argv = sshOrig.split()
else:
  argv = sys.argv

## if there NO arg -> rdiff-backup
if len(argv) == 1:
  os.system(default)
  sys.exit(0)

try:
  cmd = allowedCmd[argv[1]]
except:
  print 'Unknown command!'
  sys.exit(1)

os.system('%s %s' % ( cmd, ' '.join(argv[2:]) ) )
sys.exit(0)
