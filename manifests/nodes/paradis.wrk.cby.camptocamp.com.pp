node 'paradis.wrk.cby.camptocamp.com' {
  $c2c_workstation_users = ["pierre","elemoine","pmauduit","yjacolin","fjacon","bbinet","fvanderbiest"]
  include wrk-c2c
  c2c::workstation::sadb::user{"aabt": shell => "/bin/zsh"}
}
