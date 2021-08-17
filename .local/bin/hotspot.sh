#!/bin/sh
# Usage: ./hotspot.sh <wifi-card-interface> <interface-with-internet> <wpa-ssid> <wpa-passphrase>

[ "$(whoami)" != 'root' ] && { printf 'This script needs root permission!\n'; exit 1; }

########### Initial wifi interface configuration #############
ip link set "$1" down
ip addr flush dev "$1"
ip link set "$1" up
ip addr add 192.168.28.1/24 dev "$1"

########### Start dnsmasq ##########
cat << EOF > /etc/dnsmasq.conf
interface=$1
dhcp-authoritative
dhcp-range=192.168.28.2,192.168.28.20,255.255.255.0,12h
dhcp-option=3,192.168.28.1
EOF
killall dnsmasq >/dev/null 2>&1; dnsmasq -C /etc/dnsmasq.conf

########### Start udhcpd ##########
# cat << EOF > /etc/udhcpd.conf
# start 192.168.28.2
# end 192.168.28.20
# interface $1
# remaining yes
# max_leases 10
# opt dns 8.8.8.8 8.8.4.4
# opt subnet 255.255.255.0
# opt router 192.168.28.1
# opt lease 864000
# EOF
# systemctl restart udhcpd.service
# st -e udhcpd -f &

########### Enable NAT ############
# iptables -t nat -A POSTROUTING -o "$2" -j MASQUERADE
# iptables -A FORWARD -i "$2" -o "$1" -m state --state RELATED,ESTABLISHED -j ACCEPT
# iptables -A FORWARD -i "$1" -o "$2" -j ACCEPT

# Uncomment the line below if facing problems while sharing PPPoE.
#iptables -I FORWARD -p tcp --tcp-flags SYN,RST SYN -j TCPMSS --clamp-mss-to-pmtu

# sysctl -w net.ipv4.ip_forward=1
###########

########## Start hostapd ###########
cat << EOF > /etc/hostapd/hostapd.conf
interface=$1
driver=nl80211
ssid=$3
hw_mode=g
channel=0
wmm_enabled=1
macaddr_acl=0
ignore_broadcast_ssid=0
auth_algs=1
wpa=3
wpa_passphrase=$4
wpa_key_mgmt=WPA-PSK
wpa_pairwise=TKIP CCMP
rsn_pairwise=CCMP
EOF
hostapd /etc/hostapd/hostapd.conf
