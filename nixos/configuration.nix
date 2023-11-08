{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ./disk-config.nix
    ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "wirdnix";

  time.timeZone = "Europe/Berlin";

  i18n.defaultLocale = "de_DE.UTF-8";
  console = {
    font = "Lat2-Terminus16";
    keyMap = "de";
    useXkbConfig = true; # use xkbOptions in tty.
  };

#   users.users.root.openssh.authorizedKeys.keys = [
#     # change this to your ssh key
#     (builtins.readFile ~/.ssh/id_rsa.pub)
#   ];
  users.users.wirdnix = {
    description = "Thomas Wienecke";
    isNormalUser = true;
    # hashedPassword = lib.fileContents ./secrets/demery-hashed-password;
    openssh.authorizedKeys.keys = [
        (builtins.readFile ~/.ssh/id_rsa.pub)
    ];
    uid = 1000;
    extraGroups = [
      "docker"
      "wheel"
    ];
    packages = with pkgs; [
      cmatrix
    ];
  };
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
    settings.PasswordAuthentication = false;
  }

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