#!/bin/bash
NUM=$#

# function to uncomment any important lines
uncomment () {
    sudo sed -i "/^#$1/s/^#//" $2
}

# requires exactly two arguments, doesn't matter what they are.
if [ "$NUM" -ne 2 ]; then
    echo 'Incorrect number of arguments provided.'
    exit 0
fi

# installing some necessary packages
sudo apt-get install dnsmasq
sudo apt-get install hostapd
.

# add to dhcpcd.conf
echo "

denyinterfaces wlan0" >> /etc/dhcpcd.conf



# add to network/interfaces
echo "

allow-hotplug wlan0
iface wlan0 inet static
    address 192.168.4.1
    netmask 255.255.255.0
    network 192.168.4.0
    broadcast 192.168.4.255
    
" >> /etc/network/interfaces

# add to hostapd, which consists of the actual details of the stand-alone network
echo "
interface=wlan0
driver=nl80211
ssid=$1
hw_mode=g
channel=7
wmm_enabled=0
macaddr_acl=0
auth_algs=1
ignore_broadcast_ssid=0
wpa=2
wpa_passphrase=$2
wpa_key_mgmt=WPA-PSK
wpa_pairwise=TKIP
rsn_pairwise=CCMP
" >> /etc/hostapd/hostapd.conf



# configuration for the network
echo "

interface=wlan0
listen-address=192.168.4.1
bind-interfaces
server=8.8.8.8
domain-needed
bogus-priv
dhcp-range=192.168.4.100,192.168.4.200,24h

" >> /etc/dnsmasq.conf



# uncomment DAEMON_CONF for hostapd
sudo sed -i 's/^.*DAEMON_CONF.*/DAEMON_CONF="\/etc\/hostapd\/hostapd.conf"/g' /etc/default/hostapd


# ip forwarding, uncomment
uncomment "net.ipv4.ip_forward=1" /etc/sysctl.conf


# final setups
sudo sh -c "iptables-save > /etc/iptables.ipv4.nat"
sudo iptables -t nat -A  POSTROUTING -o eth0 -j MASQUERADE


sudo sed -i "/^exit 0/s//iptables-restore < \/etc\/iptables.ipv4.nat/" /etc/rc.local
# ip tables restore
sudo sed -i "/^exit 0/s///" /etc/rc.local
echo "
exit 0
" >> f.txt

# done with updates, now can start all of the necessary servicesL
# next time the pi boots up, it will have its own network.

sudo systemctl restart dhcpcd
sudo systemctl reload dnsmasq
sudo systemctl unmask hostapd
sudo systemctl enable hostapd
sudo systemctl start dhcpcd
sudo systemctl start hostapd
sudo systemctl start dnsmasq
sudo reboot
