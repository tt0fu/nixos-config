sudo mkdir /etc/wireguard
sudo cp "$1" "/etc/wireguard/$2.conf"
sudo chmod 700 "/etc/wireguard/$2.conf"
