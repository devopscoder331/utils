# Simple run OpenVPN


### Create dirs and configs

```bash
mkdir -p ~/openvpn/{conf,data}
cd ~/openvpn
```

### Generate configs

```bash
docker run --rm -v $PWD/conf:/etc/openvpn kylemanna/openvpn ovpn_genconfig -u udp://$(curl -s ifconfig.me)
```

### Init PKI 

```bash
docker run --rm -it -v $PWD/conf:/etc/openvpn -v $PWD/data:/var/lib/openvpn kylemanna/openvpn ovpn_initpki
```

You will need to:
1. Enter the password for the CA (remember it!)
2. Specify the Common Name (you can leave it by default)
3. Wait for the keys to be generated

### Run docker container

```bash
docker run --name openvpn \
--restart unless-stopped \
-v $PWD/conf:/etc/openvpn \
-v $PWD/data:/var/lib/openvpn \
-p 1194:1194/udp \
--cap-add=NET_ADMIN \
-d kylemanna/openvpn
```

### Create client congfigs

```bash
# create client (without pass)
docker run --rm -it -v $PWD/conf:/etc/openvpn -v $PWD/data:/var/lib/openvpn kylemanna/openvpn easyrsa build-client-full CLIENTNAME nopass

# Generate .ovpn config
docker run --rm -v $PWD/conf:/etc/openvpn -v $PWD/data:/var/lib/openvpn kylemanna/openvpn ovpn_getclient CLIENTNAME > CLIENTNAME.ovpn
```

Now the file CLIENTNAME.ovpn will be in your home directory. Use it to connect via OpenVPN client.
