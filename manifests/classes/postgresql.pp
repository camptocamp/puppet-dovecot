class postgresql {
  case $lsbdistcodename {
    etch: {
      include postgresql::v8-1
    }

    lenny: {
      include postgresql::v8-3
    }
  }
}
