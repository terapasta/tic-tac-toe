#!/bin/sh

set -ex

pid=`ps ax | grep [s]lappy | awk '{print $1}'`
if [ $pid -gt 0 ]; then
  kill -9 $pid
fi

cd /var/www/donusagi-bot/current/slack-bot
RAILS_ENV=production nohup bundle exec slappy start > /dev/null 2>&1 &
