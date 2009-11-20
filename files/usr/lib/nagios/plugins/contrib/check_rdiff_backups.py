#!/usr/bin/env python
# Nagios plusgin to check errors and missing backups

logsDir = "/var/log/rdiff-backup/"
thld_hour = 4 # Hour of day after which todays backup should be present


import os, sys
import re
import datetime

log_name_re = re.compile("(.*)-(\d{2})-(\d{2})-(\d{4})\.log")

hosts = {}
logs = {}
for log_file in os.listdir(logsDir):
  host, day, month, year = log_name_re.match(log_file).groups()
  date = "%s-%s-%s" %(year, month, day)

  if host not in hosts or date > hosts[host]:
    hosts[host] = date
    logs[host] = log_file

hosts_ok = []
now = datetime.datetime.now()
for host, date in hosts.items():
  if date == now.strftime("%Y-%m-%d") or now.hour < thld_hour and date == (now - timedelta(days=1)).strftime("%Y-%m-%d"):
    for line in open(os.path.join(logsDir, logs[host])):
      if line.strip() == "Errors 0":
        hosts_ok.append(host)
        break


problem_hosts = list(set(hosts.keys()) - set(hosts_ok))

if problem_hosts:
  print "CRITICAL: %s/%s missing" %(len(problem_hosts), len(hosts))
  sys.exit(2)

else:
  print "OK"
