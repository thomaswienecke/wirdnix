# Setup of wirdnix homelab server

This describes how to setup this nixos configuration on a baremetal machine using [nixos-anywhere](https://github.com/nix-community/nixos-anywhere). Checkout their [Quickstart](https://github.com/nix-community/nixos-anywhere/blob/main/docs/quickstart.md) for more information.


## Prerequisites

### deployment machine with nix installed
* experimental features enabled by adding `experimental-features = nix-command flakes` to `/etc/nix/nix.conf` (on macos)
* add `trusted-users = @wheel root thomas;` to `/etc/nix/nix.conf` (on macos) and reboot
  * this should make `nix store ping` return `Trusted 1` (needed for `--build-on-remote` due to aarch64 m1 mac)


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

## Install Nixos using Nixos-Anywhere
* Run `nix run github:numtide/nixos-anywhere -- --flake .#wirdnix --vm-test` to test config in VM (not working on m1 mac due to aarch64)
* Run `nix run github:numtide/nixos-anywhere -- --build-on-remote --flake .#wirdnix root@wirdnix.wienecke`
  * This will format the Disko disks and install nixos
  * remove machine from .ssh/known_hosts if it was already connected to before

## Rebuild Nixos using nix shell escape hatch
* Clone git repo using `git clone git@github.com:thomaswienecke/wirdnix.git`
* Run `nix shell nixpkgs#nixos-rebuild`
* Run `nixos-rebuild switch --fast --use-remote-sudo --flake .#wirdnix --build-host "wirdnix@wirdnix.wienecke" --target-host "wirdnix@wirdnix.wienecke"`

# Acknowledgements
Thanks to [@danielemery](https://github.com/danielemery) for the inspiration for nixos-disko
