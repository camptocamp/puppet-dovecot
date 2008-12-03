class mysql::server::medium inherits mysql::server {

# Implementation of my-medium.cnf provided as an example with mysql
# distribution.
# This is for a system with little memory (32M - 64M) where MySQL plays
# an important part, or systems up to 128M where MySQL is used together with
# other programs (such as a web server).

  Augeas["my.cnf/performance"] {
    changes => [
     "set mysqld/key_buffer 16M",
     "set mysqld/max_allowed_packet 1M",
     "set mysqld/table_cache 64",
     "set mysqld/sort_buffer_size 512K",
     "set mysqld/read_buffer_size 256K",
     "set mysqld/read_rnd_buffer_size 512K",
     "set mysqld/net_buffer_length 8K",
     "set mysqld/myisam_sort_buffer_size 8M",
     "set mysqldump/max_allowed_packet 16M",
     "set isamchk/key_buffer 20M",
     "set isamchk/sort_buffer_size 20M",
     "set isamchk/read_buffer 2M",
     "set isamchk/write_buffer 2M",
     "set myisamchk/key_buffer 20M",
     "set myisamchk/sort_buffer_size 20M",
     "set myisamchk/read_buffer 2M",
     "set myisamchk/write_buffer 2M"
    ]
  }
}
