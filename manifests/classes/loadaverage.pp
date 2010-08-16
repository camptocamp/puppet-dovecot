# override default values by setting $monitoring_load_warn and
# $monitoring_load_crit in your node definition.
class monitoring::loadaverage {

  if !$monitoring_load_warn {
    $w1 = $processorcount * 3
    $w2 = $processorcount * 2
    $w3 = $processorcount * 1
    $monitoring_load_warn = "${w1},${w2},${w3}"
  }
  if !$monitoring_load_crit {
    $c1 = $processorcount * 6
    $c2 = $processorcount * 4
    $c3 = $processorcount * 3
    $monitoring_load_crit = "${c1},${c2},${c3}"
  }

  monitoring::check { "Load Average":
    codename => "check_load_average",
    command  => "check_load",
    options  => "-w ${monitoring_load_warn} -c ${monitoring_load_crit}",
  }
}
