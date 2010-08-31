class mw-postgresql-8-3 {

  include postgresql::v8-3
  include postgresql::administration

  package {"python-psycopg2":
    ensure => present,
  }

}
