{
  helium,
  pkgs,
  pkgsUnstable,
  ...
}:

{
  home = {
    packages = [
      pkgs.ghostty
      pkgs.git
      pkgs.github-cli
      pkgs.kdePackages.dolphin
      pkgs.neovim

      pkgsUnstable.claude-code
      pkgsUnstable.pi-coding-agent

      helium.packages.${pkgs.stdenv.hostPlatform.system}.default
    ];

    stateVersion = "26.05";
  };

  programs.bash = {
    enable = true;
    shellAliases = {
      rebuild = "sudo nixos-rebuild switch --flake /etc/nixos";
      vi = "nvim";
    };
  };

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  dconf.settings."org/gnome/desktop/interface".color-scheme = "prefer-dark";

  xdg.mimeApps = {
    enable = true;
    defaultApplications."inode/directory" = "org.kde.dolphin.desktop";
  };
}
