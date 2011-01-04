class dovecot::debian inherits dovecot::base {

  Package["Dovecot"] {
    name => "dovecot-common",
  }

  Package["Dovecot IMAP"] {
    name => "dovecot-imapd",
  }

  Package["Dovecot POP3"] {
    name => "dovecot-pop3d",
  }

  Service["dovecot"] {
    pattern => "dovecot",
  }

}
