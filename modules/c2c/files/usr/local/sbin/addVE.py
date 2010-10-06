#!/usr/bin/env python
# file managed by puppet
import sys,urllib2,glob,time,types
import os.path
from os import system
from commands import getstatusoutput

BRIDGES = {	
	"10.27.20"   : 'br20', 
	"10.27.21"   : 'br21',
	"128.179.66" : 'br22',
}

VZDIR = "/vz/private"

NETCONF = """# This file describes the network interfaces available on your system
# and how to activate them. For more information, see interfaces(5).

# The loopback network interface
auto lo
iface lo inet loopback

# The primary network interface
auto eth0
iface eth0 inet static
        address %(ip)s
        netmask 255.255.255.0
        gateway %(gateway)s
"""

CPUUNITS_PER_UNIT = 2 * 50000 # 2 GHz
MB_PER_UNIT = 2 * 1024        # 2 GB

def execCmdLive(cmd, msg):
    status = os.system(cmd)
    if status:
        print "%s failed, abort !" % msg
	sys.exit(1)

def execCmd(cmd, msg):
    status, output = getstatusoutput(cmd)
    if status:
        print "%s failed, abort !" % msg
        sys.exit(1)
    return output

def getBridge(ip):
    subnet = ".".join(ip.split(".")[:-1])
    if not BRIDGES.has_key(subnet):
       print "No bridge found for SUBNET %s" % subnet
       sys.exit(1)
    return subnet, BRIDGES[subnet]

def setInterfaces(hostname, name, ip, subnet, veid):
    interfaceFile = os.path.join(VZDIR, "%s/etc/network/interfaces" % veid)
    fInterface = open(interfaceFile,'w')
    fInterface.write(NETCONF % {'ip' : ip, 'gateway' : subnet+'.1'})
    fInterface.close()

def installBase(veid, environment):
    execCmdLive("vzctl start %s" % veid, "Start VE %s" % veid)
    time.sleep(10)
    execCmdLive("vzctl exec %s '/usr/bin/wget -O - http://sa.camptocamp.com/d-i/install-puppet.sh | sh'" % veid, "Wget install puppet script")
    execCmdLive("vzctl exec %s '/usr/sbin/puppetd --ssldir /var/lib/puppet/ssl -t --server pm.camptocamp.net --environment %s'" % (veid, environment), "Start puppet")

def addVE(veid,name,bridge,template, cpu, mem):
    execCmdLive("vzctl create %s --ostemplate %s" % (veid, template), "Create VE %s" % veid)
    execCmdLive("vzctl set %s --hostname %s --save" % (veid, name), "Set hostname")
    execCmdLive("vzctl set %s --netif_add eth0 --save" % veid, "Set netif_add")
    execCmdLive("vzctl set %s --applyconfig default --save" % veid, "Set applyconfig")
    execCmdLive("vzctl set %s --onboot yes --save" % veid, "Set onboot")
    execCmdLive("vzctl set %s --features nfs:on --save" % veid, "Set NFS enable")
    execCmdLive("vzctl set %s --diskspace $[1024*1024*5] --save" % veid, "Set disk quota to 5G")
    execCmdLive("vzctl set %s --cpuunits %s --save" % (veid, int(cpu)*CPUUNITS_PER_UNIT ), "Set CPU limit")
    execCmdLive("vzctl set %s --privvmpages %sM --save" % (veid, int(mem)*MB_PER_UNIT ), "Set memory limit")
    execCmdLive("echo NETIF_BRIDGE='%s' >> /etc/vz/conf/%s.conf" % (bridge, veid), "Set netif_bridge")


### interactive part
def getdata(url):
    '''
    opens %url% and maps its output into a list of dictionnaries
    '''
    try:
        result = urllib2.urlopen(url).readlines()
    except urllib2.HTTPError:
        return []
    cols = result[0].strip().split(";")
    items = map(lambda item:dict(zip(cols, item.strip().split(";"))), result[1:])
    return items

def getIp(hostname):
    result = execCmd("host %s" % hostname, "Check DNS entry for %s" % hostname)
    return result.split()[-1]

def getUnits(veid):
    d = getdata('http://sadb.camptocamp.com/vserver/search/veid/%s'%veid)
    return int(float(d[0]['cpu'])),int(float(d[0]['memory']))

def getHostname(veid):
    d = getdata('http://sadb.camptocamp.com/vserver/search/veid/%s'%veid)
    return d[0]['hostname']

def getVars():
    environment = raw_input('Environment: ')
    veid = raw_input('VEID: ')
    hostname = getHostname(veid)
    name = hostname.split('.')[0]
    ip = getIp(hostname)
    cpu, mem = getUnits(veid)

    return (environment, veid, hostname, name, ip, cpu, mem)

if __name__=="__main__":
    if len(sys.argv) != 9:
      environment, veid, hostname, name, ip, cpu, mem = getVars()
    else:
      environment = sys.argv[1]
      veid = sys.argv[2]
      hostname = sys.argv[3]
      name = sys.argv[4]
      ip = sys.argv[5]
      cpu = sys.argv[6]
      mem = sys.argv[7]
      template = sys.argv[8]
    subnet, bridge = getBridge(ip)
    addVE(veid, name, bridge, template, cpu, mem)
    setInterfaces(hostname, name, ip, subnet, veid)
    installBase(veid, environment)
