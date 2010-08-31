class mysql::server::large inherits mysql::server {

# Implementation of my-large.cnf provided as an example with mysql
# distribution.
# This is for a large system with memory = 512M where the system runs mainly
# MySQL.

  Augeas["my.cnf/performance"] {
    changes => [
     "set mysqld/key_buffer 256M",
     "set mysqld/max_allowed_packet 1M",
     "set mysqld/table_cache 256",
     "set mysqld/sort_buffer_size 1M",
     "set mysqld/read_buffer_size 1M",
     "set mysqld/read_rnd_buffer_size 4M",
     "set mysqld/net_buffer_length 8K",
     "set mysqld/myisam_sort_buffer_size 64M",
     "set mysqld/thread_cache_size 8",
     "set mysqld/query_cache_size 16M",
     "set mysqld/thread_concurrency 8",
     "set mysqldump/max_allowed_packet 16M",
     "set isamchk/key_buffer 128M",
     "set isamchk/sort_buffer_size 128M",
     "set isamchk/read_buffer 2M",
     "set isamchk/write_buffer 2M",
     "set myisamchk/key_buffer 128M",
     "set myisamchk/sort_buffer_size 128M",
     "set myisamchk/read_buffer 2M",
     "set myisamchk/write_buffer 2M"
    ]
  }
}
