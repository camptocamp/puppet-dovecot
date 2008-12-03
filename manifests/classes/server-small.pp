class mysql::server::small inherits mysql::server {

# Implementation of my-small.cnf provided as an example with mysql
# distribution.
# This is for a system with little memory (<= 64M) where MySQL is only used
# from time to time and it's important that the mysqld daemon
# doesn't use much resources.

  Augeas["my.cnf/performance"] {
    changes => [
     "set mysqld/key_buffer 16K",
     "set mysqld/max_allowed_packet 1M",
     "set mysqld/table_cache 4",
     "set mysqld/sort_buffer_size 64K",
     "set mysqld/read_buffer_size 256K",
     "set mysqld/read_rnd_buffer_size 256K",
     "set mysqld/net_buffer_length 2K",
     "set mysqld/thread_stack 64K",
     "set mysqldump/max_allowed_packet 16M",
     "set isamchk/key_buffer 8M",
     "set isamchk/sort_buffer_size 8M",
     "set myisamchk/key_buffer 8M",
     "set myisamchk/sort_buffer_size 8M"
    ]
  }
}
