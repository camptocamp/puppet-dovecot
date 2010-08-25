#!/usr/bin/ruby

# file managed by puppet

File.open("/var/cache/nagios/status.dat", "r") do |file|

  inblock = false
  status = Hash.new
  service = nil

  states = { "0" => "OK", "1" => "WARNING", "2" => "CRITICAL", "3" => "UNKNOWN" }

  file.each_line do |line|

    if line.match(/^servicestatus \{/)
      inblock = true
      service = Hash.new
    end

    inblock = false if line.match(/^\s*\}/)

    if inblock and line.match(/^\s([a-z_]+)=(.*)$/)
      service["#{$1}"] = $2
    end

    if !inblock and service
      servicename = service["check_command"]
      status[servicename] = service
    end

  end

  status.each do |s,t|
    print "+++ %s (%s) - %s\n\n  %s\n  %s\n  %s\n  %s\n\n\n" % [
      t["service_description"],
      t["check_command"],
      "Status: " + states[t["current_state"]],
      "Last check: " + Time.at(t["last_check"].to_i).asctime,
      "Next check: " + Time.at(t["next_check"].to_i).asctime,
      "Last state change: " + Time.at(t["last_state_change"].to_i).asctime,
      t["plugin_output"],
    ]
  end

end
