=====================
Bazaar Puppet module
=====================

This module is provided to you by Camptocamp_.

.. _Camptocamp: http://www.camptocamp.com/


------------
Dependencies
------------
os module: git://github.com/camptocamp/puppet-os.git

-------
Purpose
-------
Install bzr server and manage its repositories
Install client packages


-------
Example
-------
Server node, with some repositories::
  node "myserver" {
    include bazaar::server
    bazaar::repository {"toto":
      ensure => present,
      groupe => bzr_dev,
    }
    bazaar::repository {"titi":
      ensure => absent,
    }
  }

