#!/bin/bash
NUM=$#

if [ "$NUM" -ne 2 ]; then
    echo 'Incorrect number of arguments provided.'
    exit 0
fi


sudo apt install rng-tools
sudo systemctl mask networking.service
sudo systemctl mask dhcpcd.service
sudo mv /etc/network/interfaces /etc/network/interfaces~
sudo sed -i '1i resolvconf=NO' /etc/resolvconf.conf
sudo systemctl enable systemd-networkd.service
sudo systemctl enable systemd-resolved.service
sudo ln -sf /run/systemd/resolve/resolv.conf /etc/resolv.conf

NUM=$#

cat > /etc/wpa_supplicant/wpa_supplicant-wlan0.conf <<EOF
country=DE
ctrl_interface=DIR=/var/run/wpa_supplicant GROUP=netdev
update_config=1

network={
    ssid="$1"
    mode=2
    key_mgmt=WPA-PSK
    psk="$2"
    frequency=2437
}
EOF

sudo chmod 600 /etc/wpa_supplicant/wpa_supplicant-wlan0.conf
sudo systemctl enable wpa_supplicant@wlan0.service
cat > /etc/systemd/network/08-wlan0.network <<EOF
[Match]
Name=wlan0
[Network]
Address=192.168.4.1/24
DHCPServer=yes
EOF

sudo reboot
