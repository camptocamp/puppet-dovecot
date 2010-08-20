module Puppet::Parser::Functions
  newfunction(:ldap_user_lookup, :type => :rvalue) do |args|
    username = args[0]
    field = args[1]

    cmd = "ldapsearch -LLL -x -b 'ou=Users,dc=ldap,dc=c2c' 'uid=#{username}' #{field} | egrep '^#{field}:' | sed 's/^#{field}: //'"
    Puppet.debug "Running external command: #{cmd}"
    %x[#{cmd}].strip!
  end
end
