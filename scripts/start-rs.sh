#!/bin/bash

MONGODB0=`ping -c 1 mongo0 | head -1  | cut -d "(" -f 2 | cut -d ")" -f 1`
MONGODB1=`ping -c 1 mongo1 | head -1  | cut -d "(" -f 2 | cut -d ")" -f 1`
MONGODB2=`ping -c 1 mongo2 | head -1  | cut -d "(" -f 2 | cut -d ")" -f 1`

echo "Wait for ..."
sleep 5

mongo --host ${MONGODB0} --port 27017 <<EOF
   var cfg = {
        "_id": "rs",
        "version": 1,
        "members": [
            {
                "_id": 0,
                "host": "${MONGODB0}:27017",
                "priority": 2
            },
            {
                "_id": 1,
                "host": "${MONGODB1}:27017",
                "priority": 0
            },
            {
                "_id": 2,
                "host": "${MONGODB2}:27017",
                "priority": 0
            }
        ]
    };
    rs.initiate(cfg, { force: true });
    rs.reconfig(cfg, { force: true });
EOF

if [ $? -eq 0 ];then
   echo "Mongo replica set is UP!"
else
   echo "Fail to run Mongo replica set"
   exit 1
fi
