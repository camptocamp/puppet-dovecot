class geste::mail {
  $postfix_relayhost = "psemail.epfl.ch"
  $valid_fqdn = $fqdn
  $root_mail_recipient = "cedric.jeanneret@camptocamp.com"
  include postfix::satellite
}
