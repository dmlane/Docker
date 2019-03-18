#!/bin/sh

function extract_info {
awk 'BEGIN {var="2010-01-01"}{
    if($1=="url:") {
        sub(/^.*url: */,"")
        printf "%s:",$0
        }
    if(/Next sync will download from:/) {
        cmd="date -d \""$6" "$7" "$8"\" +\"%Y-%m-%d\""
        cmd | getline var
        close(cmd)
    }
}
END {
    print var
}'
}

case $1 in
	save)	
		>/tmp/greg.state
		for feed in $(greg list)
		do
		    printf "%s:" $feed >>/tmp/greg.state
		    greg info $feed|extract_info >>/tmp/greg.state
		done
		mv -f /tmp/greg.state /output/
		:;;
	remove)
		 echo y|greg remove $2
		 :;;
	restore)
		width=$(cut -d : -f1 /output/greg.state |wc -L)
		sed 's/\([^:]*\):\(.*\):\([^:]*\)$/printf "%${width}s: " "\1";greg add \1 \2 \&\& greg edit --downloadfrom \3 \1 \&\& echo restored/' /output/greg.state >/tmp/restore.sh
		. /tmp/restore.sh
		:;;
	sync)
		for feed in $(greg list)
		do
			echo Downloading $feed .............
			greg sync $feed
		done
		:;;
	*)	greg $*
		:;;
esac
		
		
