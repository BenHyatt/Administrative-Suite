#!/bin/bash
red=$(tput setaf 1)
green=$(tput setaf 2)
reset=$(tput sgr0)
temp=$(vcgencmd measure_temp | head -c 9 | tail -c 4)
date=$(date)
storage=($(df -h|awk 'NR==2'|awk '{print $5}'))
ram=($(free -h|awk 'NR==2'|awk '{print $4}'))
users=$(who | wc -l)
uptime_1=$(uptime|awk '{print $3}')
uptime=$(uptime|awk '{print $4}')
uptime=${uptime::-1}
if [ "$users" == "1" ]
then
        message="is ${red}1${reset}"
else
        message="are ${red}$users${reset}"
fi
echo "Today is ${red}$date${reset}."
echo "You are using ${red}$storage${reset} of storage."
echo "You have ${red}$ram${reset} RAM available."
echo "There $message different SSH connections."
echo "The CPU temperature is ${red}$temp°C${reset}."
echo "The server has been up for ${red}$uptime_1 $uptime${reset}."
echo -e
echo "Server-Statistics is produced by ${green}Ben Corp Solutions${reset}"
