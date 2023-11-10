{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware/hardware-configuration.nix
      ./hardware/disk-config.nix
    ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Load ZFS pool
  boot.supportedFilesystems = [ "zfs" ];
  networking.hostId = "5505b5a5";
  boot.zfs.forceImportRoot = false;
  boot.zfs.extraPools = [ "datapool" ];

  networking.hostName = "wirdnix";

  time.timeZone = "Europe/Berlin";

  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    font = "Lat2-Terminus16";
    keyMap = "de";
  };
  
  users.users.wirdnix = {
    description = "Thomas Wienecke";
    isNormalUser = true;
    # hashedPassword = lib.fileContents ./secrets/demery-hashed-password;
    openssh.authorizedKeys.keys = [
        "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDHThzA2eGRUvFZslEf8hvjb8NMKtWgeskSWXVX0epyacG3tKD4g0Jz1UJSww0zOda9oqpqIdsqpvLEN734GMw+JE6ESPsqy2FeZ5izgJoGe/o81M9ihVzZu5wKn2G43rxaW1ywq7UZpnsdwtNj73kYOVAFJxCsPVuJgyN0GFwww+NXX+WVMCq4Wi7O+yysxxFSdZaebSG23MjFB/TAdd8TPMxQygL+VGR9BewZTTWVau4JvcQCkYUHyMoijeb+/lea/xtoZ8z+ylqzCLycojHonrM1vsVhqFAubEbsCYZMp2BuKhkTZsOUehIaznxJ+8miKTf8bQLmPH/1y1mbkaRPlkvkuN8AfZ9azaJp4cBQjPc5ayrBIqG6k0zavtwnqZWEr40aYTpTKdmWHUfn0Ky6AFb7mt2QHEdKULSWeGjxyJwow1cRRNbCMrHn4dCC/VNCDOYBtTYx6Ey9AiYI+ih0FKy8LQl4trv7aVLG4MmW/RUoorBRk3hKXzKUp/U+V58= thomas@MacBook-Pro-von-Thomas.local"
    ];
    uid = 1000;
    extraGroups = [
      "docker"
      "wheel"
    ];
  };

  # wirdnix user can elevate to root without password
  security.sudo.extraRules = [
    {
      users = [ "wirdnix" ];
      commands = [
        {
          command = "ALL";
          options = [ "NOPASSWD" ];
        }
      ];
    }
  ];

  environment.systemPackages = with pkgs; [
    curl
    git
    btop
    powertop
    dig
  ];

  services.openssh = {
    enable = true;
    settings = {
      PasswordAuthentication = false;
      PermitRootLogin = "no";
    };
  };

  virtualisation = {
    docker = {
      enable = true;
      autoPrune = {
        enable = true;
        dates = "weekly";
      };
    };
  };

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It's perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.05"; # Did you read the comment?

  nix = {
    package = pkgs.nixFlakes;
    extraOptions = "experimental-features = nix-command flakes";
  };
}