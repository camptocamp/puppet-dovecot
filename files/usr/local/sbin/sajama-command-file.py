#!/usr/bin/env python
import os, sys, commands

ionice = commands.getstatus('which ionice')
if ionice:
  allowedCmd = {'rdiff':'nice -n 10 rdiff-backup --server', 'vzlist':'vzlist -H -o veid,hostname', 'version':'rdiff-backup -V'}
  default = 'nice -n 10 rdiff-backup --server'
else:
  allowedCmd = {'rdiff':'nice -n 10 ionice -n 7 rdiff-backup --server', 'vzlist':'vzlist -H -o veid,hostname', 'version':'rdiff-backup -V'}
  default = 'nice -n 10 ionice -n 7 rdiff-backup --server'

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
