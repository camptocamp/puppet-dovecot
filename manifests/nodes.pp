# Each node must be defined in nodes/$fqdn.pp
import "nodes/*.pp"

# Default node handling
node default {
    fail "Connection from an unconfigured host: ${fqdn}"
}
