#!/usr/bin/env ruby

require 'open-uri'

begin
  puts "#"
  puts "# This puppet recipe is generated with the script get-c2c-sadb-users.rb"
  puts "#"
  puts "define app::c2c::sadb::users ($ensure=present, $groups=false) {"
  open('http://sadb.camptocamp.com/user/internal/') {|f|
    f.each_line {|line| 
      args = line.split(";")
      uid = args[1]
      if uid != 'uid' and ["ssh-rsa","ssh-dss"].include?(args[6])
        print <<EOF

  c2c::sshuser {\"#{uid}\": 
    ensure  => $ensure, 
    uid     => url_get(\"${sadb}/user/#{uid}/uid_number\"),
    comment => sprintf(\"%s %s\", url_get(\"${sadb}/user/mbornoz/firstname\"), url_get(\"${sadb}/user/mbornoz/lastname\")),
    email   => url_get(\"${sadb}/user/#{uid}/email\"), 
    type    => url_get(\"${sadb}/user/#{uid}/ssh_pub_key_type\"),
    key     => url_get(\"${sadb}/user/#{uid}/ssh_pub_key\"),
    groups  => $groups, 
  }
EOF
     end
    }
  }
  puts "}"
rescue OpenURI::HTTPError => error
  fail "Fetching URL #{url} failed with status #{error.message}"
end

