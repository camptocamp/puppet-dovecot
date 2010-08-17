import "classes/*.pp"
import "definitions/*.pp"

/*

== Class openvz
Install an openvz hardware node.

*/
class openvz {
  include openvz::server
}
