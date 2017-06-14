#!/bin/bash
#Define color variables
red=$(tput setaf 1)
green=$(tput setaf 2)
reset=$(tput sgr0)
#Function to add one line break before message
e()
{
	echo -e
	echo "$1"
}
#Makes it easier to have line breaks around messages
break_message()
{
        echo -e
        echo "$1"
        echo -e
}
leave()
#Function to exit the program.
{
        break_message "Bye!"
        exit 0
}
#Function to check user input if they want to leave the program.
check()
{
        if [ "$1" == "quit" -o "$1" == "Quit" -o "$1" == "q" -o "$1" == "Q" ]
        then
                leave
        fi
}
#Function to verify user doesn't accidentally kick themselves.
self_check()
{
        me=($(who am i --ips|awk '{print $2}'))
        if [ "$me" == "$1" ]
        then
		echo -e
                read -p "${red}You are going to kick yourself.${reset}  Y or Yes to continue.  " answer
                check "$asnwer"
                if [ "$answer" == "yes" -o "$answer" == "y" -o "$answer" == "Y" -o "$answer" == "Yes" ]
                then
                        break_message "Proceding..."
                else
                        check "$answer"
                        e "Aborting..."
                        main
                fi
        fi
}
#Clear the screen
clear
break_message "Welcome to Kick by Ben Corp Solutions.  If you ever want to leave type quit."
#Display logged in users
who
echo -e
main() {
        while true
	do
		#Prompt users for who they want to kick
                read -p "Enter the pts id of the session you wish to terminate (e.x. pts/0). "  username
                if [ "$username" == "" ]
                then
                        e "Please enter something."
                else
                        self_check "$username"
			check "$username"
			#Check if who they want to kick is included in who is online
			if [[ $(who | awk '{print $2}') == *$username* ]]
			then
				#Previous number of online users
				previous=$(who | wc -l)
				#Finally, the kick command!
                        	pkill -9 -t "$username"
				#New number of online users
				new=$(who | wc -l)
				#Check if the previous number of users is the new number + 1
				if [[ $((new + 1)) -eq $previous ]]
				then
                        		e "${green}The kick was successful!${reset}"
				else
					e "${red}The kick failed${reset}"
				fi
			else
				e "${red}Invalid session id.${reset}";
			fi
                fi
        done
}
main
