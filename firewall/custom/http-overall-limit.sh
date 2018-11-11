#!/bin/bash

## Limit the amount of connections on port 80 per remote-ip
## this rule does NOT open port 80. it just drops "too many connections" on port 80

CONNECTIONS=5
HTTP=80,443
IPTABLES=/sbin/iptables

$IPTABLES -A INPUT -p tcp --syn -m multiport --dports $HTTP -m connlimit --connlimit-above $CONNECTIONS -j REJECT