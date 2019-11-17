#!/bin/bash

# virb-autoimport-cron.sh

PIDFILE=/home/pi/virb-autoimport-cron.pid
VIRB_DIR="/mnt/backups/virb"
AUTOIMPORT_DIR="/home/pi/virb-autoimport/"
AUTOIMPORT_COMMAND="ruby main.rb"


# do pid ding

if [ -f $PIDFILE ]
then
  PID=$(cat $PIDFILE)
  ps -p $PID > /dev/null 2>&1
  if [ $? -eq 0 ]
  then
    # echo "Process already running"
    exit 1
  else
    ## Process not found assume not running
    echo $$ > $PIDFILE
    if [ $? -ne 0 ]
    then
      # echo "Could not create PID file"
      exit 1
    fi
  fi
else
  echo $$ > $PIDFILE
  if [ $? -ne 0 ]
  then
    # echo "Could not create PID file"
    exit 1
  fi
fi

# loop door virb_dir: voor elke dir
# 	check of dir nog bestaat
# 	voer main.rb uit met dir als virb_path parameter

sudo mount -a

if [ -d "$VIRB_DIR" ]; then
	for virbpath in "$VIRB_DIR"; do
		cd $AUTOIMPORT_DIR
    	$AUTOIMPORT_COMMAND --virb_path "$virbpath"
	done
fi

rm $PIDFILE
