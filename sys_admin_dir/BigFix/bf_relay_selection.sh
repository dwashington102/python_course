#!/usr/bin/bash

:<<COMMENTS
Script generates a besclient.config file used by BigFix client
The besclient.config file is built using internal relays and external relays, along with fallback (altRelays)
COMMENTS

# Changelog
# 2022-05-11:  v1 of script

stop_client (){
# Stop the TEM Client
service besclient stop
sleep 10
}

reset_client (){
:<<COMMENTS
Function removes the existing besclient.config.saved file and copies existing besclient.config before
deleting the existing besclient.config 
COMMENTS
# Reset the TEM Client
pushd /var/opt/BESClient &>/dev/null
rm -f besclient.config.saved
cp -f besclient.config besclient.config.saved
rm -f besclient.config
touch besclient.config
}

set_relays (){
# Prepare the new besclient.config file
internalRelays=("xxx.xxx0xxx.xxx3xxx.10" "xxx.xxx0xxx.xxx35.18xxx" "xxx.xxx0xxx.xxx51.1xxx4" "xxx.xxx0xxx.xxxxxx4.xxx4" "xxx.xxx0xxx.xxx30.xxx15" "xxx.xxx0xxx.xxxxxx4.83")
externalRelays=("5xxx.118.134.131" "14xxx.81.1xxxxxx.73" "5xxx.117.7xxx.xxx3xxx" "14xxx.81.1xxxxxx.8xxx")

altRelays=("xxx.xxx0xxx.xxx3xxx.10;5xxx.118.134.131;xxx.xxx14.13xxx.1xxx;xxx.xxx0xxx.xxx35.18xxx;14xxx.81.1xxxxxx.73;xxx.xxx0xxx.xxx51.1xxx4;5xxx.117.7xxx.xxx3xxx;xxx.xxx0xxx.xxxxxx4.xxx4;14xxx.81.1xxxxxx.8xxx;xxx.xxx0xxx.xxx30.xxx15;xxx.xxx0xxx.xxxxxx4.83;xxx.xxx14.17.xxx03;xxx.xxx14.17.xxx04"
 "xxx.xxx14.13xxx.1xxx;5xxx.118.134.131;xxx.xxx0xxx.xxx3xxx.10;14xxx.81.1xxxxxx.8xxx;xxx.xxx0xxx.xxx51.1xxx4;xxx.xxx14.17.xxx04;xxx.xxx0xxx.xxx35.18xxx;xxx.xxx14.17.xxx03;xxx.xxx0xxx.xxxxxx4.xxx4;xxx.xxx0xxx.xxxxxx4.83;5xxx.117.7xxx.xxx3xxx;xxx.xxx0xxx.xxx30.xxx15;14xxx.81.1xxxxxx.73"
 "xxx.xxx0xxx.xxx3xxx.10;14xxx.81.1xxxxxx.8xxx;xxx.xxx14.13xxx.1xxx;xxx.xxx0xxx.xxx35.18xxx;14xxx.81.1xxxxxx.73;xxx.xxx0xxx.xxx51.1xxx4;5xxx.117.7xxx.xxx3xxx;xxx.xxx0xxx.xxxxxx4.83;xxx.xxx14.17.xxx03;xxx.xxx0xxx.xxx30.xxx15;xxx.xxx0xxx.xxxxxx4.xxx4;xxx.xxx14.17.xxx04;5xxx.118.134.131"
 "xxx.xxx0xxx.xxx30.xxx15;xxx.xxx14.13xxx.1xxx;14xxx.81.1xxxxxx.73;5xxx.117.7xxx.xxx3xxx;xxx.xxx0xxx.xxxxxx4.xxx4;xxx.xxx0xxx.xxx3xxx.10;xxx.xxx14.17.xxx04;xxx.xxx0xxx.xxxxxx4.83;14xxx.81.1xxxxxx.8xxx;xxx.xxx0xxx.xxx35.18xxx;xxx.xxx14.17.xxx03;xxx.xxx0xxx.xxx51.1xxx4;5xxx.118.134.131")

internalRandom=$(( ( RANDOM % ${#internalRelays[*]} ) ))
externalRandom=$(( ( RANDOM % ${#externalRelays[*]} ) ))
altRandom=$(( ( RANDOM % ${#altRelays[*]} ) ))
relayServer1=${internalRelays["$internalRandom"]}
relayServer2=${externalRelays["$externalRandom"]}
altRelays=${altRelays["$altRandom"]}
}

create_config (){
echo '[Software\BigFix\EnterpriseClient]' >> besclient.config
echo 'EnterpriseClientFolder         = /opt/BESClient' >> besclient.config
echo '' >> besclient.config
echo '[Software\BigFix\EnterpriseClient\GlobalOptions]' >> besclient.config
echo 'StoragePath                    = /var/opt/BESClient' >> besclient.config
echo 'LibPath                        = /opt/BESClient/BESLib' >> besclient.config
echo '' >> besclient.config
echo '[Software\BigFix\EnterpriseClient\Settings\Client\_BESClient_EMsg_File]' >> besclient.config
echo 'value                          = /var/opt/BESClient/besclientdebug.log' >> besclient.config
echo '' >> besclient.config
echo '[Software\BigFix\EnterpriseClient\Settings\Client\_BESClient_EMsg_Detail]' >> besclient.config
echo '' >> besclient.config
echo 'value                          = 0' >> besclient.config
echo '[Software\BigFix\EnterpriseClient\Settings\Client\__RelaySelect_Automatic]' >> besclient.config
echo 'value                          = 0' >> besclient.config
echo '' >> besclient.config
echo '[Software\BigFix\EnterpriseClient\Settings\Client\__RelayServer1]' >> besclient.config
echo "value                          = http://$relayServer1:52311/bfmirror/downloads/" >> besclient.config
echo '' >> besclient.config
echo '[Software\BigFix\EnterpriseClient\Settings\Client\__RelayServer2]' >> besclient.config
echo "value                          = http://$relayServer2:52311/bfmirror/downloads/" >> besclient.config
echo '' >> besclient.config
echo '[Software\BigFix\EnterpriseClient\Settings\Client\C_Code]' >> besclient.config
echo 'value							= I001' >> besclient.config
echo '' >> besclient.config
echo '[Software\BigFix\EnterpriseClient\Settings\Client\_BESClient_RelaySelect_FailoverRelayList]' >> besclient.config
echo "value = $altRelays" >> besclient.config
echo '' >> besclient.config
echo '[Software\BigFix\EnterpriseClient\Settings\Client\_BESClient_Report_MinimumInterval]' >> besclient.config
echo 'value							= 300' >> besclient.config

#delete contents of __BESData
rm -fr __BESData
}

start_client (){
# Restart the TEM Client
service besclient restart
}


MAIN (){
    stop_client
    reset_client
    set_relays
    create_config
    start_client
}

MAIN
printf "\n"
