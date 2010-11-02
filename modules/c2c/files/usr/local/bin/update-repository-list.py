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
  packages[repo] = {}

  distribs = [x for x in os.listdir(r_path + "/dists/") if os.path.isdir(r_path + "/dists/" + x)]
  for distrib in distribs:
    d_path = r_path + "/dists/" + distrib
    packages[repo][distrib] = {}

    components = [x for x in os.listdir(d_path) if os.path.isdir(d_path + "/" + x)]
    for component in components:
      c_path = d_path + "/" + component
      packages[repo][distrib][component] = {}

      archs = [x.split("-",1)[1] for x in os.listdir(c_path) if x.startswith("binary-") and os.path.isdir(c_path + "/" + x)]
      for arch in archs:
	a_path = c_path + "/binary-" + arch

	packages_data = gzip.open(a_path + "/Packages.gz", 'rb').read()
        pname = pversion = None
	for line in packages_data.split("\n"):
          if not line and pname is not None:
	    if pname in packages[repo][distrib][component]:
	      packages[repo][distrib][component][pname]["arch"].append(arch)
	    else:
	      packages[repo][distrib][component][pname] = {"version": pversion, "arch": [arch]}
	  elif line.startswith("Package:"):
	    pname = line.split(" ",1)[1]
          elif line.startswith("Version:"):
	    pversion = line.split(" ",1)[1]


      if not packages[repo][distrib][component]:
	del packages[repo][distrib][component]

    if not packages[repo][distrib]:
      del packages[repo][distrib]

  if not packages[repo]:
    del packages[repo]


# Create HTML
html = """<html>
<head>
<title>Camptocamp Debian/Ubuntu package repositories</title>
<style  TYPE="text/css">
body { font-family:sans-serif; }
div.repo { background-color: #afa; padding: 10px; margin: 10px; }
div.distrib { background-color: #faa; padding: 10px; margin: 10px; }
div.component { background-color: #fff; padding: 10px; margin: 10px; }
th { text-align: left; }
td.p_name { width: 15em; }
td.p_version { width: 15em; }
</style>
</head>
<body>
<p>Repository pkg.camptocamp.net - updated on %s
""" %(time.strftime("%Y-%m-%d %H:%M:%S"))
for repo in repos:
  html += '<div class="repo"><h1>%s</h1>\n' %(repo)

  for distrib in packages[repo].keys():
    html += '<div class="distrib"><h2>%s</h2>\n' %(distrib)

    for component in packages[repo][distrib].keys():
      html += '<div class="component"><h3>%s</h3>\n' %(component)

      html += '<table><tr><th class="p_name">Package</th><th class="p_version">Version</th><th class="p_archs">Archs</th></tr>\n'

      packages_names = packages[repo][distrib][component].keys()
      packages_names.sort()
      for package in packages_names:
        infos = packages[repo][distrib][component][package]
	html += '<tr><td class="p_name">%s</td><td class="p_version">%s</td><td class="p_archs">%s</td></tr>\n' %(package, infos["version"], " ".join(infos["arch"]))

      html += '</table>'

      html += '</div>'
    html += '</div>'
  html += '</div>'

html += """</body>
</html>
"""

print html
