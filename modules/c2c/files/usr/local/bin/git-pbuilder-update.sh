#!/bin/bash

ARCHS="i386 amd64"
PBUILDERDIR=/var/cache/pbuilder
DISTS="ubuntu-lucid debian-squeeze debian-lenny"
UBUNTU_MIRROR="http://mirror.switch.ch/ftp/mirror/ubuntu"
DEBIAN_MIRROR="http://mirror.switch.ch/ftp/mirror/debian"
UBUNTU_COMPONENTS="main restricted universe multiverse"
DEBIAN_COMPONENTS="main contrib non-free"

export http_proxy=http://proxy.lsn.camptocamp.com:3128/

for dist in $DISTS; do
  id=$(echo $dist|cut -d'-' -f1)
  cn=$(echo $dist|cut -d'-' -f2)

  if [ "$id" == "debian" ]; then
    mirror=$DEBIAN_MIRROR
    components=$DEBIAN_COMPONENTS
  else
    mirror=$UBUNTU_MIRROR
    components=$UBUNTU_COMPONENTS
  fi

  for arch in $ARCHS; do
    test -d ${PBUILDERDIR}/base-${cn}-${arch}.cow && mode="update" || mode="create"
    DIST=$cn ARCH=$arch /usr/bin/git-pbuilder $mode --mirror $mirror --components "$components"
  done
done

