# Setup of wirdnix homelab server

This explains how to setup nixos on a fresh machine

## Boot machine into minimal nixos
* pikvm is physically attached to the server
* download [Nixos minimal ISO](https://nixos.org/download) directly onto pikvm
* connect iso as drive and boot the machine
* select `Install`
* `sudo -i`
* setup ssh
```
mkdir -p /root/.ssh
curl "https://github.com/thomaswienecke.keys" > /root/.ssh/authorized_keys

systemctl restart sshd
```
* connect to server via ssh
`ssh root@wirdnix.wienecke`

## Clone git repository
* nix-shell -p git
* git clone git@github.com:thomaswienecke/wirdnix.git
* cd wirdnix
* nix develop --extra-experimental-features "nix-command flakes"

## 
