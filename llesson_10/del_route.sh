sudo route del -net 212.100.54.64 gw 212.100.54.10 netmask 255.255.255.192 dev eth0
sudo route del -net 212.100.54.128 gw 212.100.54.11 netmask 255.255.255.192 dev eth0
sudo route del -net 212.100.54.192 gw 212.100.54.12 netmask 255.255.255.192 dev eth0

