node "chtopo-geocat-demo.dmz.lsn.camptocamp.com" {
  include tmpl-dev-tomcat-6

  tomcat::instance {"tomcat2":
    ensure      => present,
    group       => "c2cdev",
    server_port => 8006,
    http_port   => 8081,
    ajp_port    => 8010,
  }

  ssh-old::account::allowed_user { "jesse.eichar@camptocamp.com":
    allowed_user => "jeichar",
    system_user => "admin"
  }
  ssh-old::account::allowed_user { "emmanuel.belo@camptocamp.com":
    allowed_user => "ebelo",
    system_user => "admin"
  }

}
