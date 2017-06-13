cd /lib/bencorp_scripts
red=$(tput setaf 1)
green=$(tput setaf 2)
reset=$(tput sgr0)
if [ "$1" == "manual" ]
then
  if [ "$2" == ""  ]
  then
        echo "Here is a list of programs (and a short description) you can run using the ${green}Ben Corp Solutions Administrative Kit${reset}."
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
  if [ "$1" == "stats" ]
  then
        echo "Manual coming soon."
  fi
fi
version()
{
	sudo wget -O new_version.txt --quiet https://raw.githubusercontent.com/BenHyatt/Administrative-Suite/master/version.txt
	new_version=$(cat new_version.txt)
	sudo rm new_version.txt
	version=$(cat version.txt)
}
if [ "$1" == "version" ]
then
	version
	if [ "$new_version" == "$version" ]
	then
		echo "Your ${green}Administrative Kit${reset} is up to date."
	else
		echo "There are updates available."
	fi
fi
if [ "$1" == "update" ]
then
	version
	if [ "$new_version" == "$version" ]
	then
		echo "Your ${green}Administrative Kit${reset} is up to date."
	else
		echo "Updating."
		sudo wget --quiet -O /lib/bencorp_scripts/kick.sh https://raw.githubusercontent.com/BenHyatt/Administrative-Suite/master/kick.sh
		sudo wget --quiet -O /lib/bencorp_scripts/stats.sh https://raw.githubusercontent.com/BenHyatt/Administrative-Suite/master/server-statistics.sh
		sudo wget --quiet -O /lib/bencorp_scripts/bencorp.sh https://raw.githubusercontent.com/BenHyatt/Administrative-Suite/master/bencorp.sh
		sudo wget --quiet -O /lib/bencorp_scripts/version.txt https://raw.githubusercontent.com/BenHyatt/Administrative-Suite/master/version.txt
		sudo wget --quiet -O /lib/bencorp_scripts/update.sh https://raw.githubusercontent.com/BenHyatt/Administrative-Suite/master/update.sh
		sudo bash update.sh
		sudo rm update.sh
	fi
fi
if [ "$1" == "uninstall" ]
then
	read -p "This is going to permamentaly delete all ${green}Bencorp Administrative Suite${reset} files.  Type \"yes\" to confirm you want to continue." answer
	if [ "$answer" == "yes"
	then
		if [ "$SUDO_USER" == "" ]
		then
			echo "${red}You must run as sudo to uninstall.${reset}"
			exit 1
		fi
		cd /home/$SUDO_USER
		sudo rm /lib/bencorp_scripts -r
		cd /home/$SUDO_USER
		sed -i '/\/lib\/bencorp_scripts\//d' .bashrc
	else
		echo "${red}Aborting.${reset}"
	fi
fi
