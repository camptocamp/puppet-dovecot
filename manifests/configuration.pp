/*

= Definition: dovecot::configuration
Allow you to add new dovecot configuration.

Args:
  *$source*     source file, like puppet:///modules/foo/bar.conf
  *$content*    either inline content, or template

Note: you an only provide $content OR $source, not both of them!

*/
define dovecot::configuration($ensure=present,$source=false,$content=false) {
  if !($content or $source) {
    fail 'Please provide either $source or $content'
  }
  if ($content and $source) {
    fail 'Please provide either $source OR $content'
  }

  include dovecot::params

  case $dovecot::params::version {
    1: {
      concat::fragment {"${name}":
        ensure => $ensure,
        target => "/etc/dovecot/dovecot.conf",
        notify => Exec["reload dovecot"],
      }

      if $content {
        Concat::Fragment["${name}"] {
          content => $content,
        }
      } else {
        Concat::Fragment["${name}"] {
          source => $source,
        }
      }
    }
    2: {
      file {"/etc/dovecot/conf.d/${name}.conf":
        ensure => $ensure,
        mode   => 0644,
        owner  => root,
        group  => root,
        notify => Exec["reload dovecot"],
      }

      if $content {
        File["/etc/dovecot/conf.d/${name}.conf"] {
          content => $content,
        }
      } else {
        File["/etc/dovecot/conf.d/${name}.conf"] {
          source => $source,
        }
      }
    }
  }
}
