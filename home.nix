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

  dconf.settings."org/gnome/desktop/interface".color-scheme = "prefer-dark";
}
