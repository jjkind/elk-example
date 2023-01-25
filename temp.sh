#!/usr/bin/env bash
# Wait for a file to be created
# set -x
FILE=/data/elk/certs/ca.zip;
until [ -f  $FILE ];
do 
    echo "This process will not continue until the following file exists: "$FILE;
    sleep 10;
done;
