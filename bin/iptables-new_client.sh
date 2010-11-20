#!/bin/bash

ETH_OUT="eth0"
ETH_IN="eth2"

iptables -t mangle -F
iptables -t mangle -X

iptables -t mangle --new-chain self_out
iptables -t mangle --append OUTPUT --out-interface $ETH_OUT  --jump self_out
iptables -t mangle --append self_out --jump MARK --set-mark 0x10000011

iptables -t mangle --new-chain self_in
iptables -t mangle --append INPUT --in-interface $ETH_OUT --jump self_in
iptables -t mangle --append self_in --jump MARK --set-mark 0x11000011

iptables -t mangle --new-chain all_out
iptables -t mangle --append FORWARD --out-interface $ETH_OUT --jump all_out
iptables -t mangle --append all_out --jump MARK --set-mark 0x10000001

iptables -t mangle --new-chain all_in
iptables -t mangle --append FORWARD --in-interface $ETH_OUT --jump all_in
iptables -t mangle --append all_in --jump MARK --set-mark 0x11000001

iptables -t mangle --new-chain client1_out
iptables -t mangle --append FORWARD --out-interface $ETH_OUT --source 10.13.89.1/32 --jump client1_out
iptables -t mangle --append client1_out --jump MARK --set-mark 0x10010001

iptables -t mangle --new-chain client1_in
iptables -t mangle --append POSTROUTING --out-interface $ETH_IN --destination 10.13.89.1/32 --jump client1_in
iptables -t mangle --append client1_in --jump MARK --set-mark 0x11010001

iptables -t mangle --new-chain client2_out
iptables -t mangle --append FORWARD --out-interface $ETH_OUT --source 10.13.89.2/32 --jump client2_out
iptables -t mangle --append client2_out --jump MARK --set-mark 0x10010002

iptables -t mangle --new-chain client2_in
iptables -t mangle --append POSTROUTING --out-interface $ETH_IN --destination 10.13.89.2/32 --jump client2_in
iptables -t mangle --append client2_in --jump MARK --set-mark 0x11010002
