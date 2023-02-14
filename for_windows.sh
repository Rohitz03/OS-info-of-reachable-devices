#!/bin/bash
 
#get ip and username as arguments 
ip_address=$1
username=$2

if [ -z "$ip_address" ] || [ -z "$username" ]; 
then
  echo "Error: Both IP address and username are required."
  echo "Usage: $0 <ip_address> <username>"
  exit 1
fi

#Check if device is reachable using ping
# ping -c 1 $ip_address &> /dev/null
# if [ $? -ne 0 ]; then
#   echo "Error: Unable to reach $ip_address"
#   exit 1
# fi


# Check if device is reachable using nmap
# nmap -p 22,80,443 $ip_address


#check reachable device using netcat
nc -vz $ip_address 22 &> /dev/null

#check if netcat command was successful 
if [ $? -ne 0 ]; 
then
  echo "Error: Failed to connect to $ip_address on port 22"
  exit 1
fi

#wmic to get os and volume details
os_details=$(ssh $username@$ip_address "wmic os get Caption, Version, TotalVirtualMemorySize, FreePhysicalMemory /format:list")

vol_details=$(ssh $username@$ip_address "wmic logicaldisk get deviceid, freespace, size, systemname, volumename")

#check is ssh was successful or not
if [ $? -ne 0 ]; 
then
  echo "Error: Failed to connect to $ip_address using SSH"
  exit 1
else
  echo "OS information for $ip_address:"
  echo "$os_details"
  echo "$vol_details"
  echo "$os_details" > "$ip_address.txt"
  echo "$vol_details" >> "$ip_address.txt"
  #copy the file to remote device
  scp $ip_address.txt $username@$ip_address:$ip_address.txt
fi