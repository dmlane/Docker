#!/usr/bin/env bash

BASE_DIR=/Videos
USB_DIR=${BASE_DIR}/.usb.import
FINAL_FOLDER=${BASE_DIR}/Import
META_FOLDER=${BASE_DIR}/Metadata
REJECTS=${BASE_DIR}/Rejected

mkdir $FINAL_FOLDER $META_FOLDER $REJECTS 2>/dev/null
filter='-user 1024'

NFILES=-1
NREPEATS=24
set -o pipefail
while [ $NFILES -ne 0 ]
do
	# Find how many files in folder
	NFILES=$(find $USB_DIR -maxdepth 1 -type f -name "*.mp4"|wc -l)

	# Find how many files also match filter
	NMATCHES=$(find $USB_DIR -maxdepth 1 -type f -name "*.mp4" ${filter}|wc -l)
	
	echo "NFILES=$NFILES NMATCHES=$NMATCHES NREPEATS=$NREPEATS"
	if [ $NFILES -gt 0 ] ; then
		if [ $NMATCHES -eq 0 ] ; then
			if [ $NREPEATS -lt 1 ] ; then
				echo "NREPEATS=$NREPEATS - exiting"
				break
			fi
			(( NREPEATS-- ))
			sleep 5
			continue
		fi
	else
		break
	fi

	# We've found at least one file to process
	NREPEATS=24
	for fn in $(find $USB_DIR -maxdepth 1 -type f -name "*.mp4" ${filter})
	do
		duration=$(ffprobe -v error -show_entries format=duration -of default=noprint_wrappers=1:nokey=1 $fn)
		if [ $? -ne 0 ] ; then
			# Probably bad file - reject it for now
			mv $fn ${REJECTS}/
			echo "$fn has been rejected ........."
			continue
		fi
		f1=$(basename $fn)
		f2=${f1/.mp4/.yml}
		meta_file=${META_FOLDER}/$f2
		base=$(sed -n 's/^\(.*_.*_.*\)_[0-9]*\..*/\1/p'<<<$f1)
		[ -z "$base" ] && base=${f1%.mp4}
		sequence=$(sed -n 's/^.*_.*_.*_\([0-9]*\)\..*/\1/p'<<<$f1)
		sequence=${sequence:-0}
		duration=$(sed -E 's/0{1,5}$//'<<<$duration)
		printf -- "---\nbase: ${base}\nduration: ${duration}\nfile_name: ${f1}\nkey: %d\nkey_frames:\n" $sequence>$meta_file
		echo "FFprobing $f1 ----------"
		ffprobe -v error -skip_frame nokey -hide_banner -of default=noprint_wrappers=0 \
			-print_format flat -select_streams v:0 -show_entries frame=pkt_dts_time $fn\
			|sed -n 's/^[^"]*pkt_dts_time="\(.*\)"/  - \1/p'\
			|sed -E 's/0{1,5}$//' \
			>>$meta_file
		if [ $? -ne 0 ] ; then
			mv $fn ${REJECTS}/
			mv $metafile ${REJECTS}/
			echo "$f1 has been rejected ??????????"
			continue
		fi
		echo "processed: false">>$meta_file
		echo "state: scanned">>$meta_file
		touch -r $fn $meta_file
		mv $fn $FINAL_FOLDER/
		echo "$f1 has been processed ++++++++++"
		touch ${META_FOLDER}/.last_update.flag
	done
done

