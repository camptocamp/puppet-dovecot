define c2c::openerp-ro::user($ensure=present,$key,$type,$pg_port=5432) {
  ssh_authorized_key {$name:
    ensure  => $ensure,
    user    => openerp_ro,
    type    => $type,
    key     => $key,
    options => ["no-agent-forwarding","no-port-forwarding","no-pty","no-user-rc","no-X11-forwarding","permitopen=\"localhost:${pg_port}\""],
    require => Class["c2c::openerp-ro"],
  }
}
