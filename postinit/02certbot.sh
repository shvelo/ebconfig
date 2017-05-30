#!/bin/bash
#source env variables including node version
. /opt/elasticbeanstalk/instance.vars

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
    /opt/certbot/certbot-auto -n --no-bootstrap register --agree-tos -m $CERTBOT_EMAIL
    /opt/certbot/certbot-auto -n --no-bootstrap certonly --webroot --webroot-path=/var/well-known -d $CERTBOT_DOMAINS
fi
