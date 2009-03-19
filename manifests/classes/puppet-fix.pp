class c2c::puppet-fix {
  case $puppetversion {
    "0.24.7": {

      # http://projects.reductivelabs.com/issues/1852
      file {"/usr/lib/ruby/1.8/puppet/type/file/selcontext.rb":
        ensure => present,
        source => "puppet:///c2c/puppet-fix/selcontext-with-patch-for-1852.rb",
        owner  => "root",
        group  => "root",
        mode   => "644",
      }

      # http://projects.reductivelabs.com/issues/1922
      file {"/usr/lib/ruby/1.8/puppet/parser/ast/astarray.rb":
        ensure => present,
        source => "puppet:///c2c/puppet-fix/astarray-with-patch-for-1922.rb",
        owner  => "root",
        group  => "root",
        mode   => "644",
      }
    }
  }
}
