module Puppet::Parser::Functions
  newfunction(:eval, :doc => "Evaluate Puppet code") do |args|
    code = args[0]
    debug "Evaluating %s" % code

    # How can I get this code evaluated ?
  end
end
