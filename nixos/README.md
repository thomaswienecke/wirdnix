# Setup of wirdnix homelab server

This explains how to setup nixos on a fresh machine using nixos-anywhere and nixos-disko.

## Prerequisites

* deployment machine with nix installed
  * experimental features enabled by adding `experimental-features = nix-command flakes` to `/etc/nix/nix.conf` (on macos)

## Boot machine into minimal nixos
* Pikvm is physically attached to the server
* Download [Nixos minimal ISO](https://nixos.org/download) directly onto pikvm
* Connect ISO as a drive and boot the machine
* Select *Nixos Installer*
* Run `sudo -i` to be root
* setup ssh
```
mkdir -p /root/.ssh
curl "https://github.com/thomaswienecke.keys" > /root/.ssh/authorized_keys

systemctl restart sshd
```
* test connection to server via ssh by running `ssh root@wirdnix.wienecke` and exit afterwards

## Clone git repository
* Clone the repo by running `git clone git@github.com:thomaswienecke/wirdnix.git`
* `cd wirdnix/`

## [Disko](https://github.com/nix-community/disko) (only if disks changed)
* *SSH into server* and run `ls /dev/disk/by-id/*` to get the disk ids and exit afterwards
* Update `nixos/hardware/disks.nix` with the disk id(s)
  * Commit and Push
<!-- * Run `nix run github:nix-community/disko --extra-experimental-features "nix-command flakes" -- --mode disko ./nixos/hardware/disks.nix`
  * *CAUTION*: this will format the drives -->

## Hardware-Configuration (only if hardware changed)
* *SSH into server* and run `sudo nixos-generate-config --no-filesystems --root /mnt`
* Copy the hardware-configuration (printed by the prior command) to `nixos/hardware/hardware-configuration.nix`
  * Commit and Push

## Install Nixos
* Run `nixos-generate-config --root /mnt`
* Copy the hardware-configuration (printed by the prior command) to `nixos/hardware/hardware-configuration.nix`
  * Commit and Push
* Run `cd nixos`
* Install by running `nixos-install --flake .#wirdnix`

## Update Nixos
* Clone git repo using `git clone git@github.com:thomaswienecke/wirdnix.git`
* Run `sudo nixos-rebuild switch --flake <gitrepolocation>/nixos#wirdnix`

# Acknowledgements
Thanks to [@danielemery](https://github.com/danielemery) for the inspiration for nixos-disko
