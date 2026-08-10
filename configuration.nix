{
  config,
  lib,
  pkgs,
  ...
}:

{
  imports = [ ./hardware-configuration.nix ];

  # Boot
  # Lanzaboote replaces systemd-boot.
  boot.loader.systemd-boot.enable = lib.mkForce false;
  boot.lanzaboote = {
    enable = true;
    pkiBundle = "/var/lib/sbctl";
    # Keep kernels and initrds from filling the Windows-shared ESP.
    configurationLimit = 10;
  };
  boot.loader.efi.canTouchEfiVariables = true;
  boot.supportedFilesystems = [ "ntfs" ];

  # Hardware
  hardware.graphics.enable = true;

  # Expose the motherboard's fan controller to CoolerControl.
  boot.kernelModules = [ "nct6775" ];
  programs.coolercontrol.enable = true;

  services.xserver.videoDrivers = [ "nvidia" ];
  hardware.nvidia = {
    # Blackwell GPUs require the open kernel modules.
    open = true;
    package = config.boot.kernelPackages.nvidiaPackages.production;
    # Preserve VRAM for reliable suspend and resume.
    powerManagement.enable = true;
  };

  # Networking
  networking.hostName = "MONSTRAO";
  networking.networkmanager.enable = true;

  services.openssh = {
    enable = true;
    settings = {
      KbdInteractiveAuthentication = false;
      PasswordAuthentication = true;
      PermitRootLogin = "no";
    };
  };

  # Time and locale
  time.timeZone = "America/Sao_Paulo";
  i18n.defaultLocale = "en_US.UTF-8";

  # Desktop
  services.displayManager.gdm.enable = true;
  services.desktopManager.gnome.enable = true;
  services.gnome.core-apps.enable = false;
  environment.gnome.excludePackages = [
    pkgs.gnome-tour
    pkgs.gnome-user-docs
  ];

  # Users
  users.users.isolino = {
    isNormalUser = true;
    extraGroups = [
      "networkmanager"
      "wheel"
    ];
  };

  # Nix
  nix = {
    settings.experimental-features = [
      "nix-command"
      "flakes"
    ];

    # Keep NIX_PATH and the registry pinned to the flake's Nixpkgs.
    channel.enable = false;

    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
    };

    optimise.automatic = true;
  };

  nixpkgs.config.allowUnfree = true;

  # System administration packages
  environment.systemPackages = [
    pkgs.efibootmgr
    pkgs.sbctl
  ];

  # Keep this at the release used for the initial installation.
  system.stateVersion = "26.05";
}
