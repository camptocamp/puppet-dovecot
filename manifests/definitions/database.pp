/*

==Definition: postgresql::database

Create a new PostgreSQL database

*/
define postgresql::database(
  $ensure=present, 
  $owner=false, 
  $encoding=false,
  $template="template1",
  $source=false, 
  $overwrite=false) {

  $ownerstring = $owner ? {
    false => "",
    default => "-O $owner"
  }

  $encodingstring = $encoding ? {
    false => "",
    default => "-E $encoding",
  }

  case $ensure {
    present: {
      exec { "Create $name postgres db":
        command => "/usr/bin/createdb $ownerstring $encodingstring $name -T $template",
        user => "postgres",
        unless => "/usr/bin/psql -l | grep '$name  *|'",
      }
    }
    absent:  {
      exec { "Remove $name postgres db":
        command => "/usr/bin/dropdb $name",
        onlyif => "/usr/bin/psql -l | grep '$name  *|'",
        user => "postgres"
      }
    }
    default: {
      fail "Invalid 'ensure' value '$ensure' for postgres::database"
    }
  }

  # Drop database before import
  if $overwrite {
    exec { "Drop database $name before import":
      command => "dropdb ${name}",
      onlyif => "/usr/bin/psql -l | grep '$name  *|'",
      user => "postgres",
      before => Exec["Create $name postgres db"],
    }
  }

  # Import initial dump
  if $source {
    # TODO: handle non-gziped files
    exec { "Import dump into $name postgres db":
      command => "zcat ${source} | psql ${name}",
      user => "postgres",
      onlyif => "test $(psql ${name} -c '\\dt' | wc -l) -eq 1",
      require => Exec["Create $name postgres db"],
    }
  }
}
