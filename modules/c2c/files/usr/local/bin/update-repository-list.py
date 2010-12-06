#!/usr/bin/env python
#
# Script that creates an HTML list of packages in our debian repository
#
# Repository path fixed to /var/packages
# HTML output on stdout

repos = ("stable", "staging", "dev")


import os, sys, gzip, time

# Build packages tree

packages = {}
for repo in repos:
  r_path = "/var/packages/" + repo

  distribs = [x for x in os.listdir(r_path + "/dists/") if os.path.isdir(r_path + "/dists/" + x)]
  for distrib in distribs:
    d_path = r_path + "/dists/" + distrib
    if distrib not in packages:
      packages[distrib] = {}

    components = [x for x in os.listdir(d_path) if os.path.isdir(d_path + "/" + x)]
    for component in components:
      c_path = d_path + "/" + component
      if component not in packages[distrib]:
        packages[distrib][component] = {}

      archs = [x.split("-",1)[1] for x in os.listdir(c_path) if x.startswith("binary-") and os.path.isdir(c_path + "/" + x)]
      for arch in archs:
	a_path = c_path + "/binary-" + arch

	packages_data = gzip.open(a_path + "/Packages.gz", 'rb').read()
        pname = pversion = None
	for line in packages_data.split("\n"):
          if not line and pname is not None:
	    if pname in packages[distrib][component]:
	      packages[distrib][component][pname]["versions"][repo] = pversion
	      packages[distrib][component][pname]["archs"][repo] = arch
	    else:
	      packages[distrib][component][pname] = {"versions": {repo: pversion}, "archs": {repo: arch}}
	  elif line.startswith("Package:"):
	    pname = line.split(" ",1)[1]
          elif line.startswith("Version:"):
	    pversion = line.split(" ",1)[1]


      if not packages[distrib][component]:
	del packages[distrib][component]

    if not packages[distrib]:
      del packages[distrib]


# Create HTML
html = """<html>
<head>
<title>Camptocamp Debian/Ubuntu package repositories</title>
<style  TYPE="text/css">
body { font-family:sans-serif; }
pre  { background-color:#ddd; padding: 5px}
div.distrib { background-color: #aaf; padding: 10px; margin: 10px; }
div.component { background-color: #fff; padding: 10px; margin: 10px; }
th { text-align: left; }
th.p_name { width: 13em; }
th.p_version { width: 13em; }
td { font-family: monospace }
td.stagdiff { background-color: #ffe088; }
td.devdiff { background-color: #ffa088; }
</style>
</head>
<body>
<h2> Camptocamp Debian/Ubuntu package repositories </h2>

List of available repositories:

<pre>
http://pkg.camptocamp.net/legacy DISTRIBUTION MODULE [MODULE ...]
http://pkg.camptocamp.net/dev DISTRIBUTION MODULE [MODULE ...]
http://pkg.camptocamp.net/staging DISTRIBUTION MODULE [MODULE ...]
http://pkg.camptocamp.net/stable DISTRIBUTION MODULE [MODULE ...]
</pre>

Add the archive key using something like this:

<pre>
wget http://pkg.camptocamp.net/packages-c2c-key.gpg
apt-key add packages-c2c-key.gpg
apt-get update
</pre>

<h1>Packages lists</h2>
<p>updated: %s</p>
""" %(time.strftime("%Y-%m-%d %H:%M:%S"))
for distrib in packages.keys():
  html += '<div class="distrib"><h2>%s</h2>\n' %(distrib)

  for component in packages[distrib].keys():
    html += '<div class="component"><h3>%s</h3>\n' %(component)

    html += '<table><tr><th class="p_name">Package</th><th class="p_version">Stable</th><th class="p_version">Staging</td><th class="p_version">Dev</td></tr>\n'

    packages_names = packages[distrib][component].keys()
    packages_names.sort()
    for package in packages_names:
      versions = packages[distrib][component][package]["versions"]
      for repo in repos:
        if repo not in versions:
          versions[repo] = "-"
      staging_class = versions["staging"] != versions["stable"] and "stagdiff" or ""
      dev_class = versions["dev"] != versions["staging"] and "devdiff" or staging_class
      html += '<tr><td>%s</td><td>%s</td><td class="%s">%s</td><td class="%s">%s</td></tr>\n' %(package, versions["stable"], staging_class, versions["staging"], dev_class, versions["dev"])

    html += '</table>'

    html += '</div>'
  html += '</div>'

html += """</body>
</html>
"""

print html
