#
# A basic function to retrieve data in couchdb
#

require 'json'
require 'open-uri'

module Puppet::Parser::Functions
  newfunction(:couchdblookup, :type => :rvalue) do |args|
    
    url = args[0]
    key = args[1]

    raise Puppet::ParseError, ("couchdblookup(): wrong number of arguments (#{args.length}; must be == 2)") if args.length != 2

    begin
      json = JSON.parse(open(URI.parse(url)).read)
    rescue OpenURI::HTTPError => error
      raise Puppet::ParseError, "couchdblookup(): fetching URL #{url} failed with status #{error.message}"
    end

    result = nil
    if json.has_key?("rows") and json['total_rows'] > 0 and json['rows'][0].has_key?(key)
      result = Array.new
      json['rows'].each do |x|
        result.push(x[key])
      end
    else
      if json.has_key?(key)
        result = json[key]
      end
    end

    result or raise Puppet::ParseError, "couchdblookup(): key '#{key}' not found in JSON object !"

  end
end

