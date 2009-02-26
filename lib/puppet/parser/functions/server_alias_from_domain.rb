# create a server alias from a domain name

module Puppet::Parser::Functions
	newfunction(:server_alias_from_domain, :type => :rvalue) do |args|
		args[0].split('.')[0..2].join('.')
	end
end

