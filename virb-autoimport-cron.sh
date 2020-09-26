#!/bin/bash

# virb-autoimport-cron.sh

PIDFILE=/home/pi/virb-autoimport-cron.pid
# VIRB_DIR="/mnt/backups/virb" # on virbpi
VIRB_DIR="/media/pi/76700c60-5762-4953-b768-9c155925b5d3/virb" #on backuppi
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
	for virbpath in $VIRB_DIR/virb-expor*; do
		cd $AUTOIMPORT_DIR
    	$AUTOIMPORT_COMMAND --virb_path "$virbpath" --loglevel ERROR
	done
fi

rm $PIDFILE
