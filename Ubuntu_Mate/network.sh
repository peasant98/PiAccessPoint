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

uncomment () {
    sudo sed -i "/^#$1/s/^#//" $2
}

comment () {
    sudo sed -i "/^$1/s/^/#/" $2

}

# everything here got past the tests; is a 1 or a 0.

# 1 is to switch to its own wifi network. The name was already specified by the user here
if [ "$RES" -eq 1 ]; then
    # own wifi network
    # uncomment all of the files

    # dhcpcd.conf
    uncomment "denyinterfaces wlan0" /etc/dhcpcd.conf

    # network/interfaces
    uncomment "    address 192.168.4.1" /etc/network/interfaces
    uncomment "    netmask 255.255.255.0" /etc/network/interfaces
    uncomment "    network 192.168.4.0" /etc/network/interfaces
    uncomment "    broadcast 192.168.4.255" /etc/network/interfaces
    uncomment "iface wlan0 inet static" /etc/network/interfaces
    uncomment "allow-hotplug wlan0" /etc/network/interfaces

    # dnsmasq.conf
    uncomment "interface=wlan0" /etc/dnsmasq.conf
    uncomment "listen-address=192.168.4.1" /etc/dnsmasq.conf
    uncomment "bind-interfaces" /etc/dnsmasq.conf
    uncomment "server=8.8.8.8" /etc/dnsmasq.conf
    uncomment "domain-needed" /etc/dnsmasq.conf
    uncomment "bogus-priv" /etc/dnsmasq.conf
    uncomment "dhcp-range=192.168.4.100,192.168.4.200,24h" /etc/dnsmasq.conf
    

    # default/hostapd
    uncomment "DAEMON_CONF=" /etc/default/hostapd

    # sysctl.conf
    uncomment "net.ipv4.ip_forward=1" /etc/sysctl.conf

    # rc.local
    uncomment "iptables-restore" /etc/rc.local

    sudo systemctl start dhcpcd
    sudo systemctl start hostapd
    sudo systemctl start dnsmasq

    sudo reboot


else
    # connect with the regular wifi, going back to normal here.

    comment "denyinterfaces wlan0" /etc/dhcpcd.conf

    # network/interfaces
    comment "    address 192.168.4.1" /etc/network/interfaces
    comment "    netmask 255.255.255.0" /etc/network/interfaces
    comment "    network 192.168.4.0" /etc/network/interfaces
    comment "    broadcast 192.168.4.255" /etc/network/interfaces
    comment "iface wlan0 inet static" /etc/network/interfaces
    comment "allow-hotplug wlan0" /etc/network/interfaces

    # dnsmasq.conf
    comment "interface=wlan0" /etc/dnsmasq.conf
    comment "listen-address=192.168.4.1" /etc/dnsmasq.conf
    comment "bind-interfaces" /etc/dnsmasq.conf
    comment "server=8.8.8.8" /etc/dnsmasq.conf
    comment "domain-needed" /etc/dnsmasq.conf
    comment "bogus-priv" /etc/dnsmasq.conf
    comment "dhcp-range=192.168.4.100,192.168.4.200,24h" /etc/dnsmasq.conf
    

    # default/hostapd
    comment "DAEMON_CONF=" /etc/default/hostapd

    # sysctl.conf
    comment "net.ipv4.ip_forward=1" /etc/sysctl.conf

    # rc.local
    comment "iptables-restore" /etc/rc.local

    sudo systemctl stop dhcpcd
    sudo systemctl stop hostapd
    sudo systemctl stop dnsmasq
    sudo reboot

fi

