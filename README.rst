=================
SSH Puppet module
=================

Warning: this module contains a type and provider for ssh_authorized_key
resources which is used to work around bugs in latest puppet version.

Current workarounds:

* #1409 - ssh_authorized_key instantiation should not require the user being already present
  http://projects.reductivelabs.com/issues/1409

-----
Usage
-----

include ssh
