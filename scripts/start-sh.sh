#!/usr/bin/env bash

MONGODB0=`ping -c 1 mongo_cfg0 | head -1  | cut -d "(" -f 2 | cut -d ")" -f 1`
MONGODB1=`ping -c 1 mongo_cfg1 | head -1  | cut -d "(" -f 2 | cut -d ")" -f 1`
MONGODB2=`ping -c 1 mongo_cfg2 | head -1  | cut -d "(" -f 2 | cut -d ")" -f 1`

echo "Wait for ..."
sleep 5

mongos --port 27017 --configdb ${MONGODB0}:27019,${MONGODB1}:27019,${MONGODB2}:27019

if [ $? -eq 0 ];then
   echo "Mongo router is UP!"
else
   echo "Fail to run Mongo router"
   exit 1
fi
