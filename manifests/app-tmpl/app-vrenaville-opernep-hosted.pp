class app-vrenaville-opernep-hosted {
  common::concatfilepart {"all sudo for openerp":
    file => "/etc/sudoers",
    content => "
# as requested for package installation - list will be provided and added to puppet
openerp ALL=(ALL) NOPASSWD: ALL
",
  }
}
