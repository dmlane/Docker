#!/bin/bash

#-----------------------------------------------------------------------------
# greg_process.sh
# 
#-----


function add_series {
	local start_date=$3
	test -z "$start_date" && start_date="2010-01-01"
	greg add $1 $2
	greg edit --downloadfrom $start_date $1
}

function remove_series {
	echo y|greg remove $1
	}

function run_all {
	#--> Dump the current state of greg; one line per series 
	# Space seperated file with series, url and Next sync date
	greg info|awk -f /tmp/greg_extract.awk >/tmp/greg.state
	
	#--> See if there are any new series to add or remove
	BACKUP_NEEDED=0
	if [ -f /output/greg.state ] ; then
		for series in $( comm -13 <(cut -d " " -f1 /tmp/greg.state|sort) <(cut -d " " -f1 /output/greg.state|sort))
		do
			BACKUP_NEEDED=1
			add_series $(grep "^$series " /output/greg.state)
		done
		for series in $( comm -23 <(cut -d " " -f1 /tmp/greg.state|sort) <(cut -d " " -f1 /output/greg.state|sort))
		do
			BACKUP_NEEDED=1
			remove_series $(grep "^$series " /tmp/greg.state)
		done
	fi
	
	if [ $BACKUP_NEEDED -ne 0 ] ; then
		mv /tmp/greg.state /output/greg.state.$(date -r /tmp/greg.state +"%Y%m%d%H%M%S")	
		mv /output/greg.state /output/greg.state.change.$(date +"%Y%m%d%H%M%S")
	fi
	find /output/ -type f -name "greg.state.*" -maxdepth 1 -mtime +60 -exec rm -f {} \;
	
	#--> Process each series in turn (a generic sync stops after a failure)
	for series in $(greg list|sort)
	do
		greg sync $series 
	done
	greg info|awk -f /tmp/greg_extract.awk |sort >/tmp/greg.state
	diff /tmp/greg.state /output/greg.state >/dev/null 2>&1 ||\
		mv /tmp/greg.state /output/greg.state
}


run_all 

find /output -name "greg.log.*" -mtime +7 -exec rm -f {} \;


	
