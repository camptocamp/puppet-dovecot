class mysql::server::huge inherits mysql::server {

# Implementation of my-huge.cnf provided as an example with mysql
# distribution.
# This is for a large system with memory of 1G-2G where the system runs mainly
# MySQL.

  Augeas["my.cnf/performance"] {
    changes => [
     "set mysqld/key_buffer 384M",
     "set mysqld/max_allowed_packet 1M",
     "set mysqld/table_cache 512",
     "set mysqld/sort_buffer_size 2M",
     "set mysqld/read_buffer_size 2M",
     "set mysqld/read_rnd_buffer_size 8M",
     "set mysqld/net_buffer_length 8K",
     "set mysqld/myisam_sort_buffer_size 64M",
     "set mysqld/thread_cache_size 8",
     "set mysqld/query_cache_size 32M",
     "set mysqld/thread_concurrency 8",
     "set mysqldump/max_allowed_packet 16M",
     "set isamchk/key_buffer 256M",
     "set isamchk/sort_buffer_size 256M",
     "set isamchk/read_buffer 2M",
     "set isamchk/write_buffer 2M",
     "set myisamchk/key_buffer 256M",
     "set myisamchk/sort_buffer_size 256M",
     "set myisamchk/read_buffer 2M",
     "set myisamchk/write_buffer 2M"
    ]
  }
}
