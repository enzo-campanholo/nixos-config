{
  inputs,
  pkgs,
  ...
}:
{
  imports = [ ./hardware-configuration.nix ];

  networking = {
    hostName = "MONSTRAO";
    networkmanager.enable = true;
  };

  nixpkgs.config.allowUnfree = true;

  nix = {
    settings = {
      experimental-features = [
        "nix-command"
        "flakes"
      ];
      keep-outputs = true;
      keep-derivations = true;
    };
    channel.enable = false;
    registry.nixpkgs.flake = inputs.nixpkgs;
    nixPath = [ "nixpkgs=${inputs.nixpkgs}" ];
    gc = {
      automatic = true;
      dates = "daily";
      options = "--delete-older-than 7d";
    };
    optimise.automatic = true;
  };

  boot = {
    lanzaboote = {
      enable = true;
      pkiBundle = "/var/lib/sbctl";
      configurationLimit = 10;
    };
    kernelModules = [ "nct6775" ];
    supportedFilesystems = [ "ntfs" ];
  };

  hardware.nvidia = {
    branch = "production";
    open = true;
    powerManagement.enable = true;
  };

  services = {
    displayManager.gdm.enable = true;
    desktopManager.gnome.enable = true;
    fwupd.enable = true;
    gnome.core-apps.enable = false;
    xserver = {
      videoDrivers = [ "nvidia" ];
      xkb = {
        layout = "us,us";
        variant = ",intl";
      };
    };
  };

  environment = {
    gnome.excludePackages = with pkgs; [
      gnome-backgrounds
      gnome-color-manager
      gnome-tour
      gnome-user-docs
    ];
    systemPackages = with pkgs; [
      efibootmgr
      nautilus
      sbctl
    ];
  };

  programs = {
    coolercontrol.enable = true;
    fish.enable = true;
  };

  users.users.isolino = {
    isNormalUser = true;
    shell = pkgs.bashInteractive;
    extraGroups = [
      "networkmanager"
      "wheel"
    ];
  };

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    users.isolino = import ../../home.nix;
  };

  time = {
    timeZone = "America/Sao_Paulo";
    hardwareClockInLocalTime = true;
  };

  system.stateVersion = "26.05";
}
