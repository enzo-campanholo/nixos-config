{
  helium,
  pkgs,
  pkgsUnstable,
  ...
}:

let
  sioyekX11 = pkgs.sioyek.overrideAttrs (oldAttrs: {
    qtWrapperArgs =
      (oldAttrs.qtWrapperArgs or [ ])
      ++ [
        "--set QT_QPA_PLATFORM xcb"
        "--prefix XDG_DATA_DIRS : ${pkgs.glib.getSchemaDataDirPath pkgs.gtk3}"
      ];
  });
in
{
  home = {
    packages = [
      pkgs.ghostty
      pkgs.git
      pkgs.github-cli
      pkgs.kdePackages.dolphin
      pkgs.neovim
      sioyekX11

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
