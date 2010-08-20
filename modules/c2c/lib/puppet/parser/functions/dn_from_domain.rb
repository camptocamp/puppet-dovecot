# create a default DN from a domain name

module Puppet::Parser::Functions
	newfunction(:dn_from_domain, :type => :rvalue) do |args|
		args[0].split(/\./).map do |s| "dc=%s"%[s] end.join(",")
	end
end

