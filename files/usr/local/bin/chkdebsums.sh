#!/bin/sh

echo -e "\npkgs with missing md5sums:"
debsums -l

echo -e "\nmd5sum check of *.md5sums files:"
md5sum -c /root/md5sums

echo -e "\ndiff between /root/md5sum and reality:"
md5sum /var/lib/dpkg/info/*.md5sums | diff /root/md5sums -

echo -e "\n"

read -p "ok ? "

case $REPLY in
"ok")
    debsums_gen
    md5sum /var/lib/dpkg/info/*.md5sums > /root/md5sums
    HOME="/root" gpg --yes --detach-sign /root/md5sums
    ;;

*)
    echo "done nothing"
    ;;
esac
