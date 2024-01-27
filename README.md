# NAMADA (Testnet) one-line script
<img width="1969" alt="namada" src="https://github.com/papadritta/nam/assets/90826754/d58336e4-c32d-420d-b554-64fd02967170">

## Recommended hardware requirements
- CPU: 8 CPU
- Memory:  16 GB RAM
- Disk:  500GB+ SSD NVMe
>Storage requirements will vary based on various factors (age of the chain, transaction rate, etc)

## Official documentation:

- website page [here](https://namada.net)

- github repo [here](https://github.com/anoma/namada)

- docs & wiki [here](https://docs.namada.net/testnets)

- faucet [here](https://faucet.heliax.click)

- namada-explorer [here](https://namada-explorer.0xgen.online)


## 1. Install NAMADA node (automatic script):

>You can setup your NAMADA full node in minutes by using automated script below

>Tested on Ubuntu 22.04.2 LTS
```
wget -O run.sh  https://raw.githubusercontent.com/papadritta/nam/main/box/run.sh && chmod +x run.sh && ./run.sh
```

## 2. Update NAMADA node (automatic script):

>Script work correctly if you used source script run.sh for installation
```
on the process
```
## 3. Additional commands:

- Check status of your node:
```
sudo systemctl status namadad
```

- Check logs of your node:
```
sudo journalctl -n 100 -f -u namadad
```

## Do you need a server?
- Use the links with referal programm <a href="https://www.vultr.com/?ref=8997131"><img width="200" src="https://user-images.githubusercontent.com/90826754/200262610-b6251a9b-36a9-44f7-be30-fa691e7238de.png" a>
            <a href="https://www.digitalocean.com/?refcode=87b8b298c106&utm_campaign=Referral_Invite&utm_medium=Referral_Program&utm_source=badge"><img src="https://web-platforms.sfo2.cdn.digitaloceanspaces.com/WWW/Badge%201.svg" alt="DigitalOcean Referral Badge" /></a>

**NOTE!: use a referal link & you will get 100$ to your server provider account**
