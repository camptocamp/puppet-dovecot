class c2c::augeas inherits augeas::debian {
    Package["libaugeas0"] {
      ensure  => latest,
      require => Apt::Sources_list["c2c"],
    }

    Package["libaugeas-ruby1.8"] {
      ensure => latest,
      require => Apt::Sources_list["c2c"],
    }
}
