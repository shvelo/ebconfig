#!/bin/bash
#source env variables including node version
. /opt/elasticbeanstalk/env.vars

function error_exit
{
  eventHelper.py --msg "$1" --severity ERROR
  exit $2
}

#UNCOMMENT to update npm, otherwise will be updated on instance init or rebuild
#rm -f /opt/elasticbeanstalk/node-install/npm_updated

#download and extract desired node.js version
OUT=$( [ ! -d "/opt/elasticbeanstalk/node-install" ] && mkdir /opt/elasticbeanstalk/node-install ; cd /opt/elasticbeanstalk/node-install/ && wget -nc http://nodejs.org/dist/v$NODE_VER/node-v$NODE_VER-linux-$ARCH.tar.gz && tar --skip-old-files -xzpf node-v$NODE_VER-linux-$ARCH.tar.gz) || error_exit "Failed to UPDATE node version. $OUT" $?.
echo $OUT

#make sure node binaries can be found globally
unlink /usr/bin/node
unlink /usr/bin/npm

rm -f /usr/bin/node
rm -f /usr/bin/npm

if [ ! -L /usr/bin/node ]; then
  ln -s /opt/elasticbeanstalk/node-install/node-v$NODE_VER-linux-$ARCH/bin/node /usr/bin/node
fi

if [ ! -L /usr/bin/npm ]; then
ln -s /opt/elasticbeanstalk/node-install/node-v$NODE_VER-linux-$ARCH/bin/npm /usr/bin/npm
fi

if [ ! -f "/opt/elasticbeanstalk/node-install/npm_updated" ]; then
 echo "Try to update global NPM from version `npm -v` version to " $NPM_VER
 cd /opt/elasticbeanstalk/node-install/node-v$NODE_VER-linux-$ARCH/bin/ && /opt/elasticbeanstalk/node-install/node-v$NODE_VER-linux-$ARCH/bin/npm update npm@$NPM_VER -g
 npm install npm@$NPM_VER -g
 /opt/elasticbeanstalk/node-install/node-v$NODE_VER-linux-$ARCH/bin/npm update npm@$NPM_VER -g
 touch /opt/elasticbeanstalk/node-install/npm_updated
 echo "YAY! Updated global NPM version to `npm -v`"
else
  echo "Skipping NPM -g version update. To update, please uncomment 40install_node.sh:12"
fi


if [ ! -L /usr/bin/bower ]; then
 echo "Try to install bower globally "
 sudo npm install bower -g
 echo "Make link to use bower globally "
 ln -s /opt/elasticbeanstalk/node-install/node-v$NODE_VER-linux-$ARCH/bin/bower /usr/bin/bower
 echo "Bower installed version `bower -v`"
fi

if [ ! -L /usr/bin/yarn ]; then
 echo "Try to install yarn globally "
 sudo npm install yarn -g
 ln -s /opt/elasticbeanstalk/node-install/node-v$NODE_VER-linux-$ARCH/bin/yarn /usr/bin/yarn
fi
