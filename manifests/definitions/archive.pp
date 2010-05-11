define common::archive (
  ensure=present, 
  $src_url, 
  $digest_url="", 
  $digest_type="md5",
  $target, 
  $extension="tar.gz", 
  $timeout=120,
  $src_target="/usr/src") {

  case $extension {
    'zip' : { $extract_cmd  = "unzip ${src_target}/${name}.${extension} -d ${target}" }
    'tar.gz','tgz' : { $extract_cmd  = "tar -xzf ${src_target}/${name}.${extension} -C ${target}" }
    'tar.bz2','tbz2','tar.bz','tbz' : { $extract_cmd  = "tar -xjf ${src_target}/${name}.${extension} -C ${target}" }
    default : { notice "Unimplemented archive extension" }
  }
   
  case $digest_type {
    'md5','sha1','sha224','sha256','sha384','sha512' : { $checksum_cmd = "cd ${src_target} && ${digest_type}sum -c ${name}.${extension}.${digest_type}" }
    default: { notice "Unimplemented message digest type" }
  }

  $digest_src = $digest_url ? {
    "" => "${src_url}.${digest_type}",
    default => $digest_url,
  }

  case $ensure {
    present: {
      exec {"$name unpack":
        command => "curl -o ${src_target}/${name}.${extension} ${src_url} && curl -o ${src_target}/${name}.${extension}.${digest_type} ${digest_src} && ${checksum_cmd} && $extract_cmd",
      creates => "${src_target}/${name}.${extension}",
      timeout => $timeout,
     }
    }

    absent: {
      file {
        [
          "${target}/${name}",
          "${src_target}/${name}.${extension}",
          "${src_target}/${name}.${extension}.${digest_type}"
        ]: 
        ensure => absent,
        purge => true,
        force => true,
      }
    }

    default: { err ( "Unknown ensure value: '${ensure}'" ) }
  
  }
}
