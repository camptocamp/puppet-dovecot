define common::append_if_no_such_line($file, $line, $refreshonly = 'false') {
   exec { "/bin/echo '$line' >> '$file'":
      unless => "/bin/grep -Fxqe '$line' '$file'",
      path => "/bin",
      refreshonly => $refreshonly,
      notify => File[$file],
   }
}
