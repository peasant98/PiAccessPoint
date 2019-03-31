#!/bin/bash

echo 'Beginning the Switching Script...'
NUM=$#
if [ "$NUM" -ne 1 ]; then
    echo 'Incorrect number of arguments provided.'
    exit 0
fi

RES=$1

re='^[0-9]+$'
if ! [[ "$RES" =~ $re ]]; then
   echo "Error: Not a number."
   exit 1
fi

if [[ "$RES" -ne 1 && "$RES" -ne 0 ]]; then
    echo 'Invalid number. Select 1 or 0'
    exit 1
fi

# everything here got past the tests; is a 1 or a 0.

# 1 is to switch to its own wifi network.
if [ "$RES" -eq 1 ]; then
    # own wifi network
    sudo systemctl mask networking.service
    sudo systemctl mask dhcpcd.service
    sudo mv /etc/network/interfaces /etc/network/interfaces~
    sudo sed -i '1i resolvconf=NO' /etc/resolvconf.conf
    sudo systemctl enable systemd-networkd.service
    sudo systemctl enable systemd-resolved.service
    sudo ln -sf /run/systemd/resolve/resolv.conf /etc/resolv.conf
    sudo systemctl enable wpa_supplicant@wlan0.service
    sudo reboot


else
    # connect with the regular wifi, going back to normal here.
    sudo systemctl disable wpa_supplicant@wlan0.service
    sudo unlink /etc/resolv.conf
    sudo systemctl disable systemd-resolved.service
    sudo systemctl disable systemd-networkd.service
    sed -i '/resolvconf=NO/d' filename 
    sudo mv /etc/network/interfaces~ /etc/network/interfaces
    sudo systemctl unmask dhcpcd.service
    sudo systemctl unmask networking.service
    sudo reboot

fi


