# get the project name

module Puppet::Parser::Functions
	newfunction(:project_name_from_domain, :type => :rvalue) do |args|
		args[0].split('.')[0].gsub(/-(dev|demo)/,'')
	end
end

