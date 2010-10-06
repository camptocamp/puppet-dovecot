/*
== Class: monitoring::dell
Wrapper for dell monitoring stuff - include this class to have
all checks enabled

*/
class monitoring::dell {
  include monitoring::dell::omsa
  include monitoring::dell::snmp
  include monitoring::dell::warranty
}
