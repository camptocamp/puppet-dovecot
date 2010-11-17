class srv-c2c-search {
  $server_group = 'prod'
  $ps1label = 'search.camptocamp.com'
  include os-base
  include os-server

  include app-c2c-search
}
