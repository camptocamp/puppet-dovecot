define postgresql::user($ensure, $password = false, $superuser = false, 
                        $createdb = false, $createrole = false) {

  $passwordtext = $password ? {
    false   => "",
    default => "PASSWORD '$password' ",
  }

  $pgpass = $password ? {
    false   => "",
    default => "$password",
  }

  $superusertext = $superuser ? {
    false   => "NOSUPERUSER",
    default => "SUPERUSER",
  }

  $createdbtext = $createdb ? {
    false   => "NOCREATEDB",
    default => "CREATEDB",
  }

  $createroletext = $createrole ? {
    false   => "NOCREATEROLE",
    default => "CREATEROLE",
  }

  case $ensure {
    present: {

      # The createuser command always prompts for the password.
      # User with '-' like www-data must be inside double quotes
      exec { "Create postgres user $name":
        command => "psql -c \"CREATE USER \\\"$name\\\" $passwordtext\" ",
        user    => "postgres",
        unless  => "psql -c '\\du' | grep '^  *$name'",
        require => User["postgres"],
      }

      exec { "Set SUPERUSER attribute for postgres user $name":
        command => "psql -c 'ALTER USER \"$name\" $superusertext' ",
        user    => "postgres",
        unless  => "psql -tc \"SELECT rolsuper FROM pg_roles WHERE rolname = '$name'\" |grep -q $(echo $superuser |cut -c 1)",
        require => [User["postgres"], Exec["Create postgres user $name"]],
      }

      exec { "Set CREATEDB attribute for postgres user $name":
        command => "psql -c 'ALTER USER \"$name\" $createdbtext' ",
        user    => "postgres",
        unless  => "psql -tc \"SELECT rolcreatedb FROM pg_roles WHERE rolname = '$name'\" |grep -q $(echo $createdb |cut -c 1)",
        require => [User["postgres"], Exec["Create postgres user $name"]],
      }

      exec { "Set CREATEROLE attribute for postgres user $name":
        command => "psql -c 'ALTER USER \"$name\" $createroletext' ",
        user    => "postgres",
        unless  => "psql -tc \"SELECT rolcreaterole FROM pg_roles WHERE rolname = '$name'\" |grep -q $(echo $createrole |cut -c 1)",
        require => [User["postgres"], Exec["Create postgres user $name"]],
      }

      # change only if its not the same password
      exec { "Change password for postgres user $name":
        command => "psql -c 'ALTER USER \"$name\" $passwordtext' ",
        user    => "postgres",
        unless  => "TMPFILE=$(mktemp /tmp/.pgpass.XXXXXX) && echo 'localhost:5432:template1:$name:$pgpass' > \$TMPFILE && PGPASSFILE=\$TMPFILE psql -h localhost -c '\\q' -U $name template1 && rm -f \$TMPFILE",
        require => [User["postgres"], Exec["Create postgres user $name"]],
      }

    }

    absent:  {
      exec { "Remove postgres user $name":
        command => "psql -c 'DROP USER \"$name\" ' ",
        user    => "postgres",
        onlyif  => "psql -c '\\du' | grep '$name  *|'"
      }
    }
  
    default: {
      fail "Invalid 'ensure' value '$ensure' for postgres::user"
      }
    }
}
