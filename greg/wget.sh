#!/bin/bash

PREF=/greg/fetches
FN=${PREF}.$(date +"%Y%m%d")
printf "$1 " >>$FN
# Max of RETRIES retries ........
RETRIES=6
fails=$(cat ${PREF}.*|grep -c "$1 " )
if [ $fails -gt $RETRIES ] ; then           
        echo " SKIPPED">>$FN
        exit 0
fi             
wget $@
res=$?                  
if [ $res -eq 0 ] ; then
        echo " OK">>$FN
else                       
        echo " FAILED">>$FN
fi       
exit $res
