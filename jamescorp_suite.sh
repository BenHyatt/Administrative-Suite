cd /lib/jamescorp_suite
red=$(tput setaf 1)
green=$(tput setaf 2)
reset=$(tput sgr0)
if [ "$1" == "manual" ]
then
  if [ "$2" == ""  ]
  then
        echo "Here is a list of programs (and a short description) you can run using the ${green}James Corp Administrative Kit${reset}."
        echo "Each application has its own manual as well.  You may type \"manual\" followed by the application you want to find the manual of."
        echo -e
        echo "\"kick\" - kick users off of their SSH connections."
        echo "\"stats\" - view vital server statistics."
  fi
  if [ "$2" == "kick" ]
  then
        echo "Kick is a terminal application created on April 28 2017."
        echo "When you run the program, it will display a list of connected users.  It will then prompt you for which you want to kick off."
        echo "The program then makes sure you're kicking a valid user.  It requires confirmation if you want to kick yourself."
        echo "If you ever want to quit while using, type \"q\" or \"quit\"."
  fi
  if [ "$2" == "stats" ]
  then
        echo "Manual coming soon."
  fi
fi
version()
{
	sudo wget -O new_version.txt --quiet https://raw.githubusercontent.com/KoalaMuffin/Administrative-Suite/master/version.txt
	new_version=$(cat new_version.txt)
	\sudo rm new_version.txt
	version=$(cat version.txt)
}
 if [ "$1" == "settings" ]
  then
	cd /home/"$SUDO_USER"
	sed -i '/\/lib\/jamescorp_suite\//d' ~/.bashrc
	cd
	read -p "What custom keyword do you want to use to activate the suite? " newWord
	sudo cat >> .bashrc <<EOF
	alias $newWord='sudo bash /lib/jamescorp_suite/jamescorp_suite.sh'
	exec bash
	EOF
  fi
if [ "$1" == "version" ]
then
	version
	if [ "$new_version" == "$version" ]
	then
		echo "Your ${green}Administrative Suite${reset} is up to date."
		echo "Version: $version"
	else
		echo "${green}There are updates available.${reset}"
		echo "Your Version: $version"
		echo "Latest version: $new_version"
	fi
fi
if [ "$1" == "update" ]
then
	version
	override=0
	if [ "$2" == "-o" -o "$2" == "--override" ]
	then
		override=1
	fi
	if [ "$new_version" == "$version" -a "$override" == 0 ]
	then
		echo "Your ${green}Administrative Suite${reset} is up to date."
		echo "Version: $version"
		exit 1
	fi
	echo "Your Version: $version."
	echo "Latest version: $new_version."
	echo "${green}Updating.${reset}"
	
	sudo wget --quiet -O /lib/jamescorp_suite/suite_new.sh https://raw.githubusercontent.com/KoalaMuffin/Administrative-Suite/master/jamescorp_suite.sh
	sudo wget --quiet -O /lib/jamescorp_suite/version.txt https://raw.githubusercontent.com/KoalaMuffin/Administrative-Suite/master/version.txt
	sudo wget --quiet -O /lib/jamescorp_suite/update.sh https://raw.githubusercontent.com/KoalaMuffin/Administrative-Suite/master/update.sh
	sudo bash /lib/jamescorp_suite/update.sh
	sudo rm /lib/jamescorp_suite/update.sh
fi
if [ "$1" == "uninstall" ]
then
	read -p "This is going to permamentaly delete all ${green}Bencorp Administrative Suite${reset} files.  Type \"yes\" to confirm you want to continue. " answer
	if [ "$answer" == "yes" ]
	then
		if [ "$SUDO_USER" == "" ]
		then
			echo "${red}You must run as sudo to uninstall.${reset}"
			exit 1
		fi
		cd /home/"$SUDO_USER"
		sudo rm /lib/jamescorp_suite -r
		cd /home/"$SUDO_USER"
		sed -i '/\/lib\/jamescorp_suite\//d' .bashrc
		echo "The ${green}JamesCorp Administrative Suite 2017 ${reset} has been uninstalled."
		echo "Note, you must ${red}reboot${reset} for all changes to take effect."
	else
		echo "${red}Aborting.${reset}"
	fi
fi
if [ "$1" == "kickall" ]
then
	read -p "Are you sure you wish to continue?  This will ${red}kick all users${reset} (besides yourself) off of the machine.  This may cause ${red}data loss${reset} (there may be unsaved files).  Type \"yes\" to continue. " answer
	if [ "$answer" != "yes" ]
	then
		exit 1
	fi
	counter=0
	num=1
	me=$(who am i | awk '{print $2}')
	people=$(who | wc -l)
	while [ "$counter" -lt "$people" ]
	do
		user=$(who | awk '{print $2}' | sed -n "$num"p)
       		if [ "$user" != "$me" ]
        	then
                	sudo pkill -9 -t "$user"
        	else
                	num=$((num  + 1))
        	fi
        	counter=$((counter + 1))
	done
fi
if [ "$1" == "stats" ]
then
	temp=$(vcgencmd measure_temp | head -c 9 | tail -c 4)
	date=$(date)
	storage=($(df -h|awk 'NR==2'|awk '{print $5}'))
	ram=($(free -h|awk 'NR==2'|awk '{print $4}'))
	users=$(who | wc -l)
	uptime=$(uptime -p)
	uptime=${uptime:3}
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
	echo "The server has been up for ${red}$uptime${reset}."
	echo -e
fi
if [ "$1" == "kick" ]
then
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
	show()
	{
		if [ "$1" == "show" ]
		then
			new_who=$(who --ips)
			if [ "$new_who" == "$who" ]
			then
				echo -e
				echo "${red}Nothing has changed.${reset}"
				echo -e
				main
			else
				echo -e
				main
				echo -e
			fi
		fi
	}
	#Clear the Screen
	clear
	break_message "Welcome to Kick by ${green}Ben Corp Solutions${reset}.  If you ever want to leave type \"${red}quit${reset}\"."
	#Display logged in users
	who --ips
	who=$(who --ips)
	echo -e
	main() {
	
		while true
		do
			#Prompt users for who they want to kick
	                read -p "Enter the pts id of the session you wish to terminate (e.x. pts/0). Type \"show\" to display the most up to date list of users. "  username
	                if [ "$username" == "" ]
	                then
	                        e "Please enter something."
	                else
	                        self_check "$username"
				check "$username"
				show "$username"
				#Check if who they want to kick is included in who is online
				if [[ $(who | awk '{print $2}') == *$username* ]]
				then
					#Previous number of online users
					previous=$(who | wc -l)
					#Finally, the kick command!
	                        	sudo pkill -9 -t "$username"
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
fi
			
