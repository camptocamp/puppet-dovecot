class mysql::slave::small inherits mysql::server::small {
  include mysql::slave
}

class mysql::slave::medium inherits mysql::server::medium {
  include mysql::slave
}

class mysql::slave::large inherits mysql::server::large {
  include mysql::slave
}

class mysql::slave::huge inherits mysql::server::huge {
  include mysql::slave
}
