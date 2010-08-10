/*

==Class: postgresql::ubuntu::base

This class is dedicated to the common parts 
shared by the different flavors of Ubuntu

*/
class postgresql::ubuntu::base inherits postgresql::base {
  
  Package["postgresql"] {
    notify => Exec["pg_createcluster in utf8"],
  }
  
}
