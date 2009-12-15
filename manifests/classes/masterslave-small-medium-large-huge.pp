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

class mysql::master::small inherits mysql::server::small {
  include mysql::master
}

class mysql::master::medium inherits mysql::server::medium {
  include mysql::master
}

class mysql::master::large inherits mysql::server::large {
  include mysql::master
}

class mysql::master::huge inherits mysql::server::huge {
  include mysql::master
}
