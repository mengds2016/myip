#!/bin/bash
cd $(dirname $(realpath $0))
if [ ! -f config.sh ]; then
  echo "config file not found, will create one"
  echo "please, enter the username:"
  read username
  echo "please, enter the password:"
  read password
cat << EOF > config.sh
username="$username"
password="$password"
EOF
fi

curip=$(wget -q -O - http://ipinfo.io/ip)
previp=$(head -n 1 currentip)

if [ "$curip" != "$previp" ]; then
  echo "updating IP to $curip"
  echo $curip > currentip
  git add currentip
  git commit -m "$(date)"
  repo=$(git remote -v | grep -oP "(?<=https:\/\/)[\S]*(?= \(push\))")

  source config.sh

  git push https://$username:$password@$repo
fi

