red=$(tput setaf 1)
green=$(tput setaf 2)
reset=$(tput sgr0)
if [ "$1" == ""  ]
then
        echo "Here is a list of programs (and a short description) you can run using the ${green}Ben Corp Solutions Administrative Kit${reset}."
        echo "Each application has its own manual as well.  You may type \"manual\" followed by the application you want to find the manual of."
        echo -e
        echo "\"kick\" - kick users off of their SSH connections."
        echo "\"stats\" - view vital server statistics."
fi
if [ "$1" == "kick" ]
then
        echo "Kick is a terminal application created on April 28 2017."
        echo "When you run the program, it will display a list of connected users.  It will then prompt you for which you want to kick off."
        echo "The program then makes sure you're kicking a valid user.  It requires confirmation if you want to kick yourself."
        echo "If you ever want to quit while using, type \"q\" or \"quit\"."
fi
if [ "$1" == "kick" ]
then
        echo "Manual coming soon."
fi
