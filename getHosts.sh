#######################################################################
# 
# This script will needed to be reworked
# 
#######################################################################

echo "Creating hosts file..."

# create host file here based on local network
# if a script can not automate the process of creating an inventory the host file will need to be created manually


# if ~/.ansible.cfg doesn't exist, create it
if ! [ -f $HOME"/.ansible.cfg" ]; then
    echo "~/.ansible.cfg does not exist. Creating file now..."

    # get pwd

    pwd=$(pwd)

    python3 libgethosts/create_ansible_config.py $pwd

    echo "~/.ansible.cfg created"
fi
