cd /lib/bencorp_scripts
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
  if [ "$2" == "settings" ]
  then
       read -p "What custom keyword do you want to use to activate the suite? " custom
	sudo cat >> .bashrc <<-EOF
	alias $custom='sudo bash /lib/jamescorp_suite/jamescorp_suite.sh'
	EOF
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
	sudo rm new_version.txt
	version=$(cat version.txt)
}
if [ "$1" == "version" ]
then
	version
	if [ "$new_version" == "$version" ]
	then
		echo "Your ${green}Administrative Suite${reset} is up to date."
		echo "Version: $version"
	else
		echo "${green}There are updates available.${reset}"
		echo "Your Version: $version."
		echo "Latest version: $new_version."
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
