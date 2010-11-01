class generic-tmpl::mw-postgresql-8-4 {

  include postgresql::v8-4
  include postgresql::administration

  package {"python-psycopg2":
    ensure => present,
  }

}
