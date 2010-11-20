#!/bin/bash

RRD_DIR=/srv/qos/rrd

for rrd_file in $(/usr/bin/find ${RRD_DIR} -maxdepth 1 -mindepth 1 -type f -name "*.rrd"); do
	client_name=$(/usr/bin/basename "${rrd_file}" | /usr/bin/awk -F'.' '{ print $1; }')
	v_out=$(/sbin/iptables -vnx -t mangle -L "${client_name}_out" | /usr/bin/tail -n 1 | /usr/bin/awk '{ print $2; }')
	v_in=$(/sbin/iptables -vnx -t mangle -L "${client_name}_in" | /usr/bin/tail -n 1 | /usr/bin/awk '{ print $2; }')

	rrdtool update "${rrd_file}" "N:$v_in:$v_out"
done
