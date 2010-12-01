define samba::share($ensure=present,
    comment=false,
    path,
    read_only=no,
    create_mask=0644,
    directory_mask=0755,
    browsable=yes,
    smb_options=[]) {

  common::concatfilepart {"$name":
    ensure  => $ensure,
    file    => "/etc/samba/smb.conf",
    content => template("samba/samba-share.erb"),
    notify  => Service["samba"],
  }
}
