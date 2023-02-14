#!/bin/bash

HOST=$1
USERNAME=$2
PASSWORD=$3

if [ -z "$HOST" ] || [ -z "$USERNAME" ] || [ -z "$PASSWORD" ];
then
 echo "Error: IP address, username and password are required."
 echo "Usage: $0 <ip_address> <username> <password>"
 exit 1
fi

CMD="uname -a"

sshpass -p "$PASSWORD" ssh $USERNAME@$HOST "$CMD"
