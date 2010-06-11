# Each node must be defined in nodes/$fqdn.pp
import "nodes/*.pp"

# Default nodes
node default {
  notice "Connection from unconfigured node '$fqdn'"
}
