#!/usr/bin/bash
PORT=1445

command -v /usr/sbin/smbd &>/dev/null
if [ $? == 0 ]; then
	sambaVer=$(/usr/sbin/smbd -V | awk -F"Version " '{ print substr ($2,1,4) }')
	if [ 1 -eq $(echo "4.15 > $sambaVer" | bc -l) ]; then
	    printf "\nSamba Version: $sambaVer is less than 4.15"
	    printf "\nDEBUG >>> Full Version of Samba $(/usr/sbin/smbd -V)"
	    SMBFLAGS="-DFS"
	    printf "\nCommand: $smbcmd\n"
	else
	    printf "\nSamba Version: $sambaVer is at 4.15 or greater"
	    printf "\nDEBUG >>> Full Version of Samba $(/usr/sbin/smbd -V)"
	    SMBFLAGS="-DF --debug-stdout"
	    printf "\nCommand: $smbcmd\n"
	fi
else
	printf "\nSamba is not installed\n"
	exit 1
fi   





# Checks
if pgrep -f "/opt/ibm-kvm-samba/bin/ibm-file-sharing ${SMBFLAGS} -s $HOME/.ibm-kvm-samba/smb.conf"; then
    echo ibm-kvm-samba already running
    exit 0
fi
if lsof -iTCP:1445; then
    echo ibm-kvm-samba PORT 1445 in use
    exit 0
fi

# Clean up
if [ ! -f $HOME/.ibm-kvm-samba/.keep ]; then
    [ -d $HOME/.ibm-kvm-samba ] && rm -rf $HOME/.ibm-kvm-samba
fi

# Create a new config, each time if not exists
if [ ! -d $HOME/.ibm-kvm-samba ]; then
    mkdir -p $HOME/.ibm-kvm-samba
fi
chmod 0755 $HOME/.ibm-kvm-samba

if [ ! -f $HOME/.ibm-kvm-samba/smb.conf ]; then
    cat << EOF > $HOME/.ibm-kvm-samba/smb.conf
[global]
	## OPENCLIENT GLOBAL KVM CONFIG ##
        ## IBM service settings to disable xdg automatic start (this is not parsed by samba) ##
        workgroup = LINUXKVM
        server string = Samba Server Version %v
        bind interfaces only = yes
        interfaces = lo virbr0
        smb ports = 1445
        lock directory = $HOME/.ibm-kvm-samba
        state directory = $HOME/.ibm-kvm-samba
        cache directory = $HOME/.ibm-kvm-samba
        pid directory = $HOME/.ibm-kvm-samba
        private dir = $HOME/.ibm-kvm-samba
        ncalrpc dir = $HOME/.ibm-kvm-samba
        log file = $HOME/.ibm-kvm-samba/log.%m
        max log size = 50
        load printers = no
        cups options = raw
	username level = 10
	security = user
	map to guest = Bad Password

[shared_$(whoami)]
	## OPENCLIENT SHARE KVM CONFIG ##
        comment = Temporary file space
        path = $HOME
        read only = no
        public = yes
        guest ok = yes
        guest only = yes
        browseable = yes
        force user = $(whoami)
        create mask = 0777
        directory mask = 0777
        guest ok = Yes
        # OPENCLIENT RECYCLER
        vfs object = recycle:recycle
        recycle:subdir_mode = 0770
        recycle:repository = Recycle Bin
        recycle:keeptree = Yes
        recycle:touch = Yes
        recycle:versions = True
        recycle:maxsize = 500000000
EOF
else
    AUTOSTART=$(grep autostart $HOME/.ibm-kvm-samba/smb.conf)
    if [[ ! -z $AUTOSTART ]]; then
        AUTOSTART=$(echo $AUTOSTART | cut -d= -f2 | sed -e 's/^[[:space:]]*//' | tr '[:upper:]' '[:lower:]')
        if [[ "x$AUTOSTART" == "xno" ]]; then
            exit 0
        fi
    fi
fi

# Fix database
echo "DEBUG >>> USER: $(id -u)"
echo "DEBUG >>> GROUP: $(id -g)"
sleep 10

/opt/ibm-kvm-samba/bin/add-password $(id -u) $(id -g) $HOME > /dev/null 2>&1 ||:

# Keep running termination takes place
while true
do
    if ! pgrep -f "/opt/ibm-kvm-samba/bin/ibm-file-sharing ${SMBFLAGS} -s $HOME/.ibm-kvm-samba/smb.conf"; then
        [ -f $HOME/.ibm-kvm-samba/smbd-smb.conf.pid ] && rm -f $HOME/.ibm-kvm-samba/smbd-smb.conf.pid
        /opt/pseudohostname/fakehostname -l /opt/pseudohostname/libfakehostname.so KVM /opt/ibm-kvm-samba/bin/ibm-file-sharing $SMBFLAGS -s $HOME/.ibm-kvm-samba/smb.conf
        sleep 2
    fi
done
