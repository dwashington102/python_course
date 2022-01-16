#!/usr/bin/bash
# Script: Maps <Super># number to the various Gnome WM keybindings Virtual Workspaces
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
            #get_num=${get_ws}
            set_workspace=$(echo ${i} | awk -F'workspace-' '{print $2}')
            gsettings set ${GSETTINGKEY} ${i} "['<Super>${set_workspace}']"
        done
    print_spacer
}


MAIN (){
    func_set_num_ws
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
exit 0
