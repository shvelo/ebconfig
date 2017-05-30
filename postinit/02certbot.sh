#!/bin/bash
#source env variables including node version
. /opt/elasticbeanstalk/env.vars

function error_exit
{
  eventHelper.py --msg "$1" --severity ERROR
  exit $2
}

git clone https://github.com/certbot/certbot.git /opt/certbot
ln -s /opt/certbot/certbot-auto /bin/certbot-auto

certbot-auto -n --no-bootstrap register --agree-tos -m nick.shvelidze@in2circle.com
certbot-auto -n --no-bootstrap certonly --webroot --webroot-path=/var/well-known -d tst.sadili.ge,sadili-env-tst.elasticbeanstalk.com,www.tst.sadili.ge
