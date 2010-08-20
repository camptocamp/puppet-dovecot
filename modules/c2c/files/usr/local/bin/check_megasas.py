#!/usr/bin/python

# Ce plugin depend de l'executable MegaCli telechargeable a l'adresse 
# http://www.lsilogic.com/storage_home/products_home/internal_raid/megaraid_sas/megaraid_sas_8308elp/index.html
#
# <warn> <critical> = threads number, default 60 100
#

import re
import sys
from commands import getstatusoutput

_MEGACLI_BIN = "/opt/megacli/MegaCli"

_UNKNOWN    = -1
_OK         = 0
_WARNING    = 1
_CRITICAL   = 2

_STATUS_OK  = "Optimal"
_PREDICTIVE_FAILURE_COUNT = 0

REGEX_DISK = r"""(?s)Device Id:.(?P<id>.*?)\s+.*?Predictive Failure Count:.(?P<failure>.*?)\s+"""
REGEX_RAID = r"""(?s)State:.(?P<state>.*?)\s+.*Number.Of.Drives:(?P<nbDrive>.*?)\s+"""

def checkDiskStatus():
    status, output = getstatusoutput("%s -PDList -aALL" % _MEGACLI_BIN)
    return re.findall(REGEX_DISK, output)

def checkRaidStatus():
    status, output = getstatusoutput("%s -LDInfo -Lall -aALL" % _MEGACLI_BIN)
    return re.findall(REGEX_RAID, output)[0]

def checkStatus(nbDisk):
    result = ""
    state = ""

    # check raid status
    status, number = checkRaidStatus()
    if status <> _STATUS_OK or nbDisk <> number:
        print "CRITICAL - raid status is %s, number of drives %s/%s" % (status, number, nbDisk)
        sys.exit(_CRITICAL)
    else:
        result = "OK - %s active drives " % number
        state = _OK

    # check predictive failures
    disks = checkDiskStatus() 
    failure = False
    for id, count in disks:
        if count <> '0':
            failure = True
            break

    if failure:
        state = _WARNING
        result = "WARNING - %s active drive, disk predictive failures id:count: " % number
        for id, count in disks:
            result += "%s:%s " % (id, count)

    print result
    sys.exit(state)

def badArgs():
    print "Bad arguments !"
    usage()
    sys.exit(_UNKNOWN)

def usage():
    print "Usage: check_megasas.py NumberOfDrives"
    sys.exit(_UNKNOWN)

if __name__=="__main__":
    args = sys.argv[1:]

    if len(args) <> 1:
        badArgs()

    checkStatus(args[0])
