#!/bin/bash

RRD_DIR=/srv/qos/rrd
IMG_WATERMARK_DIR=/srv/qos/webapp/public/images
IMG_RRD_DIR=/srv/qos/webapp/public/images/rrd

DATE=`date +"%d/%m/%Y %T"`

for rrd_file in $(/usr/bin/find ${RRD_DIR} -maxdepth 1 -mindepth 1 -type f -name "*.rrd"); do
	client_name=$(/usr/bin/basename "${rrd_file}" | /usr/bin/awk -F'.' '{ print $1; }')

	for period in 10 60 1440 10080 43200; do
		rrdtool graph -E "${IMG_RRD_DIR}/${client_name}_$period.png" --title="${client_name} - $period minutes" \
		-w 700 --start "end - $period minutes" \
		DEF:${client_name}_in=${rrd_file}:${client_name}_in:AVERAGE \
		DEF:${client_name}_out=${rrd_file}:${client_name}_out:AVERAGE \
		LINE2:${client_name}_in#00ff00:"${client_name} in" \
		LINE2:${client_name}_out#ff0000:"${client_name} out" \
		--vertical-label "Bps" \
		--watermark "Onoclea QOS"

		composite -gravity center -dissolve 16 "${IMG_WATERMARK_DIR}/onoclea_logo.png" "${IMG_RRD_DIR}/${client_name}_$period.png" "${IMG_RRD_DIR}/${client_name}_$period.png"
	done
done

