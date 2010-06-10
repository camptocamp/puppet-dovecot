node 'colonney.wrk.lsn.camptocamp.com' {
  $puppet_client_version = "0.25.4-2ubuntu6"
  $c2c_workstation_users = ["ckaenzig"]
  include wrk-c2c
}
