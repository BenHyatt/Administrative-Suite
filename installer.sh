red=$(tput setaf 1)
green=$(tput setaf 2)
reset=$(tput sgr0)
if [ "$SUDO_USER" != "" ]
then
        echo "${red}You mustn't run as sudo.${reset}"
        exit 1
fi
cd
echo "Thank you for installing the ${green}Ben Corp Solutions Administrative Suite${reset}."
echo -e
sudo mkdir /lib/jamescorp_suite
echo "Downloading files..."
sudo wget --quiet -O /lib/jamescorp_suite/jamescorp_suite.sh https://raw.githubusercontent.com/KoalaMuffin/Administrative-Suite/master/bencorp.sh
sudo wget --quiet -O /lib/jamescorp_suite/version.txt https://raw.githubusercontent.com/BenHyatt/Administrative-Suite/master/version.txt
read -p "What custom keyword do you want to use to activate the suite?" custom
echo "Configurating"
sudo cat >> .bashrc <<EOF
alias $custom='sudo bash /lib/jamescorp_suite/jamescorp_suite.sh'
EOF
cd "$directory"
sudo rm installer.sh
read -p "You must ${red}reboot the server ${reset}for the ${green}Suite${reset} to work.  Do you want to reboot now (type \"yes\" to do so)? " answer
if [ "$answer" == "yes" ]
then
        sudo reboot
        exit
else
        echo -e
        echo "${green}Ok...${reset}  Remember though, you ${red}must reboot${reset} using \"sudo reboot\" for the changes to take affect."
        echo -e
fi
exit
