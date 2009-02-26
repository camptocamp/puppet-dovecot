module Puppet::Parser::Functions
  newfunction(:ldap_user_lookup, :type => :rvalue) do |args|
    username = args[0]
    field = args[1]

    case field
      when "cn" then
        cmd = 'ldapsearch -LLL -x -b "ou=Users,dc=ldap,dc=c2c" "uid=%s" cn | egrep "^cn:" | sed "s/^cn: //"' % [username]
        %x[#{cmd}].strip!
    end
  end
end
