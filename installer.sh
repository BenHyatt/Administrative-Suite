directory=$PWD
red=$(tput setaf 1)
green=$(tput setaf 2)
reset=$(tput sgr0)
if [ "$SUDO_USER" == "" ]
then
        echo "${red}You must run as sudo.${reset}"
        exit 1
fi
cd /home/$SUDO_USER
echo "Thank you for installing the ${green}Ben Corp Solutions Administrative Suite${reset}."
eco -e
check_directory()
{
        read -p "A new directory, /lib/bencorp_scripts/ ,  is going to be created.  Is this okay? Type \"yes\" to continue. " confirm
        if [ "$confirm" != "yes" ]
        then
                check_directory
        fi
}
check_directory
sudo mkdir /lib/bencorp_scripts
echo -e
echo "The applications that make up the ${green}Ben Corp Administrative Suite${reset} are now going to be installed."
sudo wget --quiet -O /lib/bencorp_scripts/kick.sh https://raw.githubusercontent.com/BenHyatt/Administrative-Suite/master/kick.sh
sudo wget --quiet -O /lib/bencorp_scripts/stats.sh https://github.com/BenHyatt/Administrative-Suite/blob/master/server-statistics.sh
sudo wget --quiet -O /lib/bencorp_scripts/manual.sh https://raw.githubusercontent.com/BenHyatt/Administrative-Suite/master/manual.sh
echo "Now in the configuration phase."
sudo cat >> .bashrc <<EOF
alias kick='bash /lib/bencorp_scripts/kick.sh'
alias stats='bash /lib/bencorp_scripts/server-statistics.sh'
alias manual='bash /lib/bencorp_scripts/manual.sh'
EOF
cd "$directory"
echo -e
echo "Deleteing installer file."
echo -e
sudo rm installer.sh
read -p "You must ${red}reboot the server ${reset}for the ${green}Suite${reset} to work.  Do you want to reboot now (type \"yes\" to do so)? " answer
if [ "$answer" == "yes" ]
then
        sudo reboot
fi
echo -e
echo "${green}Ok...${reset}  Remember though, you ${red}must reboot${reset} using \"sudo reboot\" for the changes to take affect."
echo -e
exit
