#!/usr/bin/env ruby

require 'open-uri'

begin
  absent = Array.new
  puts "#"
  puts "# This puppet recipe is generated with the script get-sadb-users.rb"
  puts "#"
  puts "define app::c2c::sadb::users ($ensure=present, $groups=false) {"
  open('http://sadb.camptocamp.com/user/internal') {|f|
    f.each_line {|line| 
      args = line.split(";")
      uid = args[1]
      if uid != 'uid' 
        if ["ssh-rsa","ssh-dss"].include?(args[6])
          print <<EOF

  c2c::sshuser {\"#{uid}\": 
    ensure  => $ensure, 
    uid     => url_get(\"${sadb}/user/#{uid}/uid_number\"),
    comment => sprintf(\"%s %s\", url_get(\"${sadb}/user/#{uid}/firstname\"), url_get(\"${sadb}/user/#{uid}/lastname\")),
    email   => url_get(\"${sadb}/user/#{uid}/email\"), 
    type    => url_get(\"${sadb}/user/#{uid}/ssh_pub_key_type\"),
    key     => url_get(\"${sadb}/user/#{uid}/ssh_pub_key\"),
    groups  => $groups, 
  }
EOF
        else
          absent.push(uid)
        end
      end
    }
  }

  puts "\n  # remove old users"
  puts "  user {" 
  absent.each {|uid|
    puts "    \"#{uid}\": ensure => absent;"
  }
  puts "  }"
  puts "}"
rescue OpenURI::HTTPError => error
  fail "Fetching URL #{url} failed with status #{error.message}"
end

