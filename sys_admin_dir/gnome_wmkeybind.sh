#!/usr/bin/bash
# Script: Maps <Super># number to the various Gnome WM keybindings Virtual Workspaces

# example:  
# If there are 3 workspaces the user inputs "3"
# The script then maps the <Super>1 to Workspace 1, <Super>2 to Workspace 2, <Super>3 to Workspace 3
# Date: 2022-01-15

# Changes

GSETTINGKEY='org.gnome.desktop.wm.keybindings'

print_spacer (){
    printf "\n"
}

# Gets the number of of workspaces from user input
func_set_num_ws (){
    printf "\nNumber of static workspaces: "
    read get_ws
    print_spacer
}

# Function maps 'Super+number' key to Gnome virtual workspaces
func_set_keybindings (){
    for i in $(gsettings list-keys ${GSETTINGKEY} | command grep -E 'switch-to.*[[:digit:]]' | sort -V | head -${get_ws})
        do
            get_num=${get_ws}
            set_workspace=$(echo ${i} | awk -F'workspace-' '{print $2}')
            gsettings set ${GSETTINGKEY} ${i} "['<Super>${set_workspace}']"
        done
    print_spacer
}

# Function removes keybindings that Gnome Dash-to-Dock sets which maps Super-1 to app-1 on the dock, Super-2 to app-2 on dock...
func_unset_keybindings (){
    SHELLKEY='org.gnome.shell.keybindings'
    loopCount=1
    while [ "$loopCount" -le "9" ]
    do
            gsettings set org.gnome.shell.keybindings switch-to-application-"$loopCount" ['']

            printf "\nUpdated Setting:\n"
            gsettings get org.gnome.shell.keybindings switch-to-application-"$loopCount" ['']
            ((loopCount++))
    done
}


MAIN (){
    func_set_num_ws
    func_unset_keybindings
    func_set_keybindings
}

MAIN
print_spacer
printf "Virtual Workspace Key Mappings"
print_spacer
    for i in $(gsettings list-keys ${GSETTINGKEY} | command grep -E 'switch-to.*[[:digit:]]' | sort -V | head -${get_ws})
        do
            printf "Workspace ${i} mapped to:\t"
            gsettings get ${GSETTINGKEY} ${i}
        done
