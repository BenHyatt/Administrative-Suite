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
sudo wget --quiet -O /lib/jamescorp_suite/jamescorp_suite.sh https://raw.githubusercontent.com/KoalaMuffin/Administrative-Suite/master/jamescorp_suite.sh
sudo wget --quiet -O /lib/jamescorp_suite/version.txt https://raw.githubusercontent.com/KoalaMuffin/Administrative-Suite/master/version.txt
sudo wget --quiet -O /lib/jamescorp_suite/changekeyword https://raw.githubusercontent.com/KoalaMuffin/Administrative-Suite/master/changekeyword
read -p "What custom keyword do you want to use to activate the suite? " custom
echo "Great! You can always use \"${green}jamescorp_suite${reset}\" as well as your key word."
echo -e
echo "Configuring..."
sudo cat >> .bashrc <<EOF
alias $custom='sudo bash /lib/jamescorp_suite/jamescorp_suite.sh'
alias jamescorp_suite='sudo bash /lib/jamescorp_suite/jamescorp_suite.sh'
EOF
sudo rm installer.sh
cd "$directory"
echo -e
echo "Thank you for installing the ${green}JamesCorp Administrative Suite${reset}."
exec bash
exit
