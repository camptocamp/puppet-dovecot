# file managed by puppet
# csv_template("http://sadb.camptocamp.com/users/internal", "c2c/c2c-user.erb")

module Puppet::Parser::Functions
  newfunction(:csv_template, :doc =>
  "Generate ressources using a CSV source (local or HTTP) and a
  template. The first line of CSV output must contain the attribute
  names. Those names will be available as variables during template
  parsing.
  ") do |args|
    require 'open-uri'
    require 'erb'

    url = args[0]
    template = args[1]
 
    debug "csv_template: Retrieving CSV from %s" % url
    debug "csv_template: Retrieving template %s" % template
 
    # First line must contain a header
    open(url, :proxy => nil) do |f|
      keys = f.readline.chomp.split(";")
      debug "csv_template: Header = %s" % keys

      f.each_line do |line|
        debug "csv_template: Line = %s" % line
        values = line.chomp.split(";")

        # Scope setup
        scope = self.newscope
        Hash[*keys.zip(values).flatten].each {|key, value|
          debug "csv_template: Setting %s to %s" % [key, value]
          scope.setvar(key, value)
        }

        wrapper = Puppet::Parser::TemplateWrapper.new(scope, template)

        begin
          debug wrapper.result()
        rescue => detail
          raise Puppet::ParseError,
            "Failed to parse template %s: %s" % [template, detail]
        end
      end
    end
   end
end
