#!/bin/bash

BLUE='\033[1;34m'
RED='\033[0;31m'
PURPLE='\033[0;35m'
NC='\033[0m'

printf "${BLUE}Installing dependencies for Ansible...${NC}\n"

### INSTALL DEPENDENCIES ###
sudo apt update -y > /dev/null
sudo apt-get install python3 python3-pip sshpass -y > /dev/null


### INSTALL PYTHON MODULES ###
sudo pip3 install pyvmomi pexpect > /dev/null


### INSTALL ANSIBLE FOR WINDOWS STUFF ###
if [ "$1" == "-w" ]; then
    printf "${BLUE}Installing extra dependencies for Ansible for Windows...${NC}\n"
    sudo apt-get install krb5-user -y > /dev/null
    sudo pip3 install pywinrm kerberos > /dev/null

### INSTALL ANSIBLE ###
elif [ "$1" == "-f" ]; then
    printf "${BLUE}Installing Ansible...${NC}\n"

    # see if Ubuntu
    DISTRO=`cat /etc/os-release | grep ^NAME | cut -d= -f2`

    ### INSTALLATION FOR UBUNTU ###
    if [ "$DISTRO" == "\"Ubuntu\"" ]; then
        sudo apt install software-properties-common -y > /dev/null
        sudo add-apt-repository --yes --update ppa:ansible/ansible > /dev/null
        sudo apt install ansible -y > /dev/null
    
    ### INSTALLATION FOR DEBIAN ###
    else
        # get debian distro
        VERSION=`cat /etc/os-release | grep VERSION_CODENAME | cut -d= -f2`

        if [ "$VERSION" == "bullseye" ]; then
            LINE="deb http://ppa.launchpad.net/ansible/ansible/ubuntu focal main"
        elif [ "$VERSION" == "buster" ]; then
            LINE="deb http://ppa.launchpad.net/ansible/ansible/ubuntu bionic main"
        elif [ "$VERSION" == "stretch" ]; then
            LINE="deb http://ppa.launchpad.net/ansible/ansible/ubuntu xenial main"
        elif [ "$VERSION" == "jessie" ]; then
            LINE="deb http://ppa.launchpad.net/ansible/ansible/ubuntu trusty main"
        else
            printf "${RED}Error - non-debian distribution detected. Please see https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html#installing-ansible-on-specific-operating-systems for how to add Ansible properly.${NC}\n"
            exit 1
        fi

        echo "$LINE" | sudo tee -a /etc/apt/sources.list
        sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 93C4A3FD7BB9C367 > /dev/null
        sudo apt update -y > /dev/null
        sudo apt install ansible -y > /dev/null
    fi

    # install needed VMware plugin
    printf "${BLUE}Installing community.vmware plugin for Ansible...${NC}\n"
    ansible-galaxy collection install community.vmware > /dev/null

### ONLY BASIC DEPENDENCIES INSTALL ###
else
    printf "\n${BLUE}Note - only Ansible dependencies are installed by default. To actually install Ansible, either run this script with the -f flag, or see https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html#installing-ansible-on-specific-operating-systems if the operating system is not supported. The community.vmware plugin must then be installed manually.${NC}\n\n"
    printf "${BLUE}Note - only Ansible for Linux has been set up on this system. To interact with Windows machines using Ansible, run this script with the -w flag.${NC}\n"
fi

printf "${PURPLE}Installation complete.${NC}\n"