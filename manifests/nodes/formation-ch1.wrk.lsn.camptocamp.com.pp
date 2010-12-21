node 'formation-ch1.wrk.lsn.camptocamp.com' {
#  include wrk-formation
      $c2c_workstation_users = ["adeshogues"]
      include wrk-c2c
}
