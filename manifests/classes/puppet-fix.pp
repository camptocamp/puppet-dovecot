class c2c::puppet-fix {
  file {"/usr/lib/ruby/1.8/puppet/type/file/selcontext.rb":
    ensure => present,
    source => "puppet:///c2c/puppet-fix/selcontext-with-patch-for-1852.rb",
    owner  => "root",
    group  => "root",
    mode   => "644",
  }
}
