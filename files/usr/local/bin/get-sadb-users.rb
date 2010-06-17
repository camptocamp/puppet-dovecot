#!/usr/bin/env ruby

require 'open-uri'

begin
  puts "#"
  puts "# This puppet recipe is generated with the script get-c2c-sadb-users.rb"
  puts "#"
  puts "define app::c2c::sadb::users ($ensure=present, $groups=false) { {\n"
  open('http://sadb.camptocamp.com/user/internal/') {|f|
    f.each_line {|line| 
      args = line.split(";")
      if args[1] != 'uid' and ["ssh-rsa","ssh-dss"].include?(args[6])
        printf("
  c2c::sshuser {'%s': 
    ensure  => $present, 
    uid     => %s, 
    comment => '%s %s', 
    email   => '%s', 
    type    => '%s',
    key     => '%s',
    groups  => $groups, 
    shell   => /bin/bash 
  }\n",  args[1], args[5], args[2], args[3], args[4], args[6], args[7])
      end
    }
  }
rescue OpenURI::HTTPError => error
  fail "Fetching URL #{url} failed with status #{error.message}"
end

