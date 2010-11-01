/*

==Class: postgresql::debian::base

This class is dedicated to the common parts 
shared by the different flavors of Debian

*/
class postgresql::debian::base inherits postgresql::base {
  
  Package["postgresql"] {
    notify => Exec["pg_createcluster in utf8"],
  }
  
}
