#!/usr/bin/env python
import urllib2,sys,os,socket,re,time
from commands import getoutput,getstatusoutput

_url = 'http://sadb.camptocamp.com/vserver'
_file = '/tmp/veStatus'
_lock = '/var/run/setvestatus.lock'
_log = '/var/log/toogle-ve-status.log'
_debug = False
_force = False
_mailLog = u''

def myLog(s):
  f = open(_log, 'a+')
  ltime = time.strftime("%Y-%m-%d %H:%M:%S", time.localtime())
  f.write(ltime+' '+str(s)+'\n')
  f.close()

def myDebug(str):
  if _debug:
    myLog(str)

def getsadb():
  try:
    data = urllib2.urlopen(_url).readlines()
  except urllib2.HTTPError:
    os.remove(_lock)
    print 'Warning : sadb seems to be down !'
    sys.exit(99)
  cols = data[0].strip().split(';')
  items = map(lambda item:dict(zip(cols,item.strip().split(';'))), data[1:])
  myDebug(items)
  return items

def getLocalVE():
  velist = getoutput("/usr/sbin/vzlist -a -H -o veid,status").split('\n')
  out = {}
  for ve in velist:
    myDebug(ve)
    veid, status = ve.split()
    out[veid] = status
  return out

def help():
  print '''-h : display this help and exits\n-f : force running\n-d : enable debug mod (see logs: %s)\n''' % _log
  sys.exit(0)

def writeFile():
  action = ['','start', 'stop']
  status = ['','running','stopped']
  onboot = ['','yes','no']
  f = open(_file, 'w+')
  ve_list = getsadb()
  local_ve = getLocalVE()
  _mailLog = u''
  
  for ve in ve_list:
    if int(ve['vserver_status_id']) < len(action):
      if ve['veid'] in local_ve and status[int(ve['vserver_status_id'])] != local_ve[ve['veid']]:
        f.write('''/usr/sbin/vzctl %s %s; /usr/sbin/vzctl set %s --onboot %s --save\n''' %
            (action[int(ve['vserver_status_id'])],ve['veid'], ve['veid'], onboot[int(ve['vserver_status_id'])]))
        myLog(
          ('''/usr/sbin/vzctl %s %s; /usr/sbin/vzctl set %s --onboot %s --save''' %
            (action[int(ve['vserver_status_id'])],ve['veid'], ve['veid'], onboot[int(ve['vserver_status_id'])]))
        )
        _mailLog += '''Toggling %s to %s \n''' % (ve['hostname'], status[int(ve['vserver_status_id'])])
  f.close()

if __name__ == '__main__':
  rgex = re.compile('.*\.mgt\.[a-z]{3}\.camptocamp\.com')
  if not rgex.match(socket.getfqdn()):
    sys.exit(0)

  if len(sys.argv) == 2:
    if sys.argv[1] == '-f':
      _force = True
    elif sys.argv[1] == '-d':
      _debug = True
    else:
      help()


  if os.path.exists(_lock) and not _force:
    print "Already running on this host"
    myLog('Already running')
    sys.exit(2)

  # lock file
  f = open(_lock,'w+')
  f.write('Running\n')
  f.close()
  
  writeFile()
  status,out = getstatusoutput('sh %s' % _file)
  os.remove(_lock)
  if status:
    print '''%s - There was an error toggling VE on this host! Please watch logs.''' % time.strftime("%Y-%m-%d %H:%M:%S", time.localtime())
    sys.exit(1)
  if _mailLog != '':
    print _mailLog
  sys.exit(0)
