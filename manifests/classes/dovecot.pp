class dovecot {
  case $operatingsystem {
    Debian : { include dovecot::debian }
    default: { fail "Nothing to do for $operatingsystem" }
  }
}
