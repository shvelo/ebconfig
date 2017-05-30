#!/bin/bash
#source env variables including node version
. /opt/elasticbeanstalk/env.vars

function error_exit
{
  eventHelper.py --msg "$1" --severity ERROR
  exit $2
}

if [ ! -d " /opt/certbot" ]; then
    git clone https://github.com/certbot/certbot.git /opt/certbot
fi
ln -sf /opt/certbot/certbot-auto /usr/bin/certbot-auto
mkdir -p /var/well-known

if [ ! -d "/etc/letsencrypt" ]; then
    /opt/certbot/certbot-auto -n --no-bootstrap register --agree-tos -m nick.shvelidze@in2circle.com
    /opt/certbot/certbot-auto -n --no-bootstrap certonly --webroot --webroot-path=/var/well-known -d tst.sadili.ge,sadili-env-tst.elasticbeanstalk.com,www.tst.sadili.ge
fi
