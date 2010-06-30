node "chtopo-geocat-dev.int.lsn.camptocamp.com" {
  include tmpl-dev-tomcat-6

  ssh-old::account::allowed_user { "jesse.eichar@camptocamp.com":
    allowed_user => "jeichar",
    system_user => "admin"
  }
  ssh-old::account::allowed_user { "emmanuel.belo@camptocamp.com":
    allowed_user => "ebelo",
    system_user => "admin"
  }
}
