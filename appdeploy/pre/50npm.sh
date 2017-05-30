#!/bin/bash
. /opt/elasticbeanstalk/env.vars
function error_exit
{
  echo $1
  eventHelper.py --msg "$1" --severity WARN
  exit $2
}

#install not-installed yet app node_modules
#echo "install not-installed yet app node_modules"
#if [ ! -d "/var/node_modules" ]; then
#  mkdir /var/node_modules ;
#fi
#if [ -d /tmp/deployment/application ]; then
#  ln -s /var/node_modules /tmp/deployment/application/
#fi

echo "run yarn install"
OUT=$([ -d "/tmp/deployment/application" ] && cd /tmp/deployment/application && /opt/elasticbeanstalk/node-install/node-v$NODE_VER-linux-$ARCH/bin/yarn install 2>&1) || error_exit "Failed to run yarn install.  $OUT" $?
echo $OUT
