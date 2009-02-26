#!/usr/bin/env python
import os, sys

sshOrig = os.getenv('SSH_ORIGINAL_COMMAND')
allowedCmd = {'rdiff':'rdiff-backup --server', 'vzlist':'vzlist -H -o veid,hostname', 'version':'rdiff-backup -V'}
cmd = ''

if sshOrig:
  argv = sshOrig.split()
else:
  argv = sys.argv

## if there NO arg -> rdiff-backup
if len(argv) == 1:
  os.system('rdiff-backup --server')
  sys.exit(0)

try:
  cmd = allowedCmd[argv[1]]
except:
  print 'Unknown command!'
  sys.exit(1)

os.system('%s %s' % ( cmd, ' '.join(argv[2:]) ) )
sys.exit(0)
