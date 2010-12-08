class c2c::puppet-client inherits puppet::client {

  if $operatingsystem =~ /Ubuntu|Debian/ {
    case $puppetversion {
      "0.25.5": {
        # Workaround for ssh_authorized_users tries to save to local filebucket as non-root user, see :
        # http://projects.puppetlabs.com/issues/4267
        file {"/usr/lib/ruby/1.8/puppet/provider/ssh_authorized_key/parsed.rb":
          ensure  => present,
          mode    => 0644,
          owner   => root,
          group   => root,
          source  => "puppet:///modules/c2c/puppet-fix/parse-with-workaround-line72.rb",
          require => Package["puppet"],
        }
      }
    }
  }
}
