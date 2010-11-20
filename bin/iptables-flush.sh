#!/bin/bash

iptables -t mangle -F
iptables -t mangle -X
iptables -F
iptables -X

iptables-restore < /etc/default/iptables.rules
