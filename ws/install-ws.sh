#!/bin/bash

rm -f $0

file_path="/etc/handeling"
repo="https://raw.githubusercontent.com/kipasu/f/main"

function Respon() {
# Cek apakah file ada
if [ ! -f "$file_path" ]; then
    # Jika file tidak ada, buat file dan isi dengan dua baris
    echo -e "Switching Protocol\nYellow" | sudo tee "$file_path" > /dev/null
    echo "File '$file_path' berhasil dibuat."
else
    # Jika file ada, cek apakah isinya kosong
    if [ ! -s "$file_path" ]; then
        # Jika file ada tetapi kosong, isi dengan dua baris
        echo -e "Switching Protocol\nYellow" | sudo tee "$file_path" > /dev/null
        echo "File '$file_path' kosong dan telah diisi."
    else
        # Jika file ada dan berisi data, tidak lakukan apapun
        echo "File '$file_path' sudah ada dan berisi data."
    fi
fi
}

function epro() {

mkdir -p /etc/websocket

curl -sL "https://raw.githubusercontent.com/izulx1/autoscript/master/ssh/ws" -o /usr/sbin/ws
chmod +x /usr/sbin/ws

cat > /etc/websocket/config.yaml << END
# verbose level 0=info, 1=verbose, 2=very verbose
verbose: 0
listen:

# // DROPBEAR
- target_host: 127.0.0.1
  target_port: 143
  listen_port: 10015

# // OpenVPN 
- target_host: 127.0.0.1
  target_port: 1194
  listen_port: 10012
END

cat > /etc/systemd/system/ws.service << END
[Unit]
Description=WebSocket
Documentation=https://github.com
After=syslog.target network-online.target

[Service]
User=root
NoNewPrivileges=true
ExecStart=/usr/sbin/ws -f /etc/websocket/config.yaml
Restart=on-failure
RestartPreventExitStatus=23
LimitNPROC=10000
LimitNOFILE=1000000

[Install]
WantedBy=multi-user.target
END

systemctl daemon-reload
systemctl enable ws
systemctl restart ws
}

apt update
apt install python3 -y
apt install python3-pip -y
apt install python3-requests -y

source /etc/os-release
if [[ ${ID} == "debian" ]]; then

  if [[ $VERSION_ID == "12" ]]; then

Respon

cd /usr/local/bin
wget -q -O vpn.zip "${repo}/ws/vpn.zip"
unzip vpn.zip
cp ws ws-ovpn
chmod +x ws ws-ovpn
rm vpn.zip
cd

# Installing Service
cat > /etc/systemd/system/ws.service << END
[Unit]
Description=Proxy Mod
Documentation=https://google.com
After=network.target nss-lookup.target

[Service]
Type=simple
User=root
CapabilityBoundingSet=CAP_NET_ADMIN CAP_NET_BIND_SERVICE
AmbientCapabilities=CAP_NET_ADMIN CAP_NET_BIND_SERVICE
NoNewPrivileges=true
ExecStart=/usr/local/bin/ws
Restart=on-failure

[Install]
WantedBy=multi-user.target
END

systemctl daemon-reload
systemctl enable ws.service
systemctl start ws.service
systemctl restart ws.service

# Installing Service
cat > /etc/systemd/system/ws-ovpn.service << END
[Unit]
Description=Proxy Mod
Documentation=https://google.com
After=network.target nss-lookup.target

[Service]
Type=simple
User=root
CapabilityBoundingSet=CAP_NET_ADMIN CAP_NET_BIND_SERVICE
AmbientCapabilities=CAP_NET_ADMIN CAP_NET_BIND_SERVICE
NoNewPrivileges=true
ExecStart=/usr/local/bin/ws-ovpn 2086
Restart=on-failure

[Install]
WantedBy=multi-user.target
END

systemctl daemon-reload
systemctl enable ws-ovpn
systemctl start ws-ovpn
systemctl restart ws-ovpn
  else
  
  epro
  
  fi

elif [[ ${ID} == "ubuntu" ]]; then

epro

fi