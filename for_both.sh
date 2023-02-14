#!/bin/bash
#get ip, username, os and password as arguments
ip_address=$1
username=$2
OS=$3
PASSWORD=$4

if [ -z "$ip_address" ] || [ -z "$username" ] || [ -z "$OS" ] || [ -z "PASSWORD" ];
then
 echo "Error: IP address, username and os name are required."
 echo "Usage: $0 <ip_address> <username> <windows or linux>"
 exit 1
fi


if [[ $OS == "linux" ]];
then
 CMD="uname -a"
elif [[ $OS == "windows" ]]; then
 CMD="wmic os get Caption, Version, TotalVirtualMemorySize, FreePhysicalMemory /format:list"
else
 echo "unsuported os: $OS"
 exit 1
fi

#check reachable device using netcat
nc -vz $ip_address 22 &> /dev/null

#check if netcat command was successful
if [ $? -ne 0 ];
then
 echo "failed to connect to $ip_address on port 22"
 exit 1
fi


#wmic to get os and volume details
if [[ $OS == "linux" ]];
then
 os_details=$(sshpass -p "$PASSWORD" ssh -o StrictHostKeyChecking=no $username@$ip_address "$CMD")
elif [[ $OS == "windows" ]];
then
 os_details=$(sshpass -p "$PASSWORD" ssh $username@$ip_address "$CMD")
fi


#check is ssh was successful or not
if [ $? -ne 0 ];
then
 echo "Failed to connect to $ip_address using SSH"
 exit 1
else
 echo "OS information for $ip_address:"
 echo "$os_details"
 echo "$os_details" > "$ip_address.txt"
fi
