node "debonix2.int.lsn.camptocamp.com" {
  $ps1label = 'debonix optimized'
  include srv-c2c-openerp-oneshot
  common::concatfilepart {'sudoers.openerp':
    file => "/etc/sudoers",
    content => "openerp ALL=(ALL) /bin/su, /bin/su -\n",
  }
}
