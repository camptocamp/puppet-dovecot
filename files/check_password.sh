#!/bin/sh

if [ "$#" -ne 2 ]; then
  echo "Usage: $0 username password"
  exit 3
fi

export PS1="yeah"

cat << EOF | expect > /dev/null 2>&1

set timeout 3
spawn /bin/su -s /bin/sh $1
expect -re "Password:"
send "$2\r"
expect {
  "yeah" { exit 99 }
  default { exit 42 }
}

EOF

case "$?" in
  42)
    echo "$1's password is not the default."
    exit 0
  ;;
  99)
    echo "$1's password hasn't been changed :-("
    exit 2
  ;;
  *)
    echo "Something went wrong with expect."
    exit 1
  ;;
esac

