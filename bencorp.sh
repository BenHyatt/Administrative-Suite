cd /lib/bencorp_scripts
echo $PWD
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
	version=$(cat version.sh)
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
		echo "Your software is up to date!"
	else
		echo "There are updates available."
	fi
fi
