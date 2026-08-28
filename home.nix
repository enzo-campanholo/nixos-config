{
  lib,
  pkgs,
  ...
}:
let
  sioyek = pkgs.sioyek.overrideAttrs (old: {
    qtWrapperArgs = (old.qtWrapperArgs or [ ]) ++ [
      "--set QT_QPA_PLATFORM xcb"
      "--prefix XDG_DATA_DIRS : ${pkgs.glib.getSchemaDataDirPath pkgs.gtk3}"
    ];
  });
in
{
  home = {
    username = "isolino";
    homeDirectory = "/home/isolino";
    stateVersion = "26.05";
    packages = [
      pkgs.helium
      sioyek
      pkgs.ocamlPackages.sail
      pkgs.z3
      pkgs.rocq-core
      pkgs.unstable.claude-code
      pkgs.unstable.pi-coding-agent
    ];
  };

  programs = {
    bash.enable = true;

    direnv = {
      enable = true;
      nix-direnv.enable = true;
    };

    emacs = {
      enable = true;
      extraPackages = epkgs: [ epkgs.proof-general ];
    };

    fish.enable = true;

    ghostty = {
      enable = true;
      settings.command = lib.getExe pkgs.fish;
    };

    gh.enable = true;

    git = {
      enable = true;
      settings.user = {
        name = "Enzo L. Campanholo";
        email = "199099542+enzo-campanholo@users.noreply.github.com";
      };
    };

    neovim = {
      enable = true;
      defaultEditor = true;
      viAlias = true;
      vimAlias = true;
    };
  };

  dconf.settings = {
    "org/gnome/desktop/input-sources".sources = [
      (lib.gvariant.mkTuple [
        "xkb"
        "us"
      ])
      (lib.gvariant.mkTuple [
        "xkb"
        "us+intl"
      ])
    ];

    "org/gnome/desktop/interface".color-scheme = "prefer-dark";

    "org/gnome/desktop/peripherals/mouse".accel-profile = "flat";
  };

  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      "application/pdf" = "sioyek.desktop";
      "application/xhtml+xml" = "helium.desktop";
      "inode/directory" = "org.gnome.Nautilus.desktop";
      "text/html" = "helium.desktop";
      "x-scheme-handler/http" = "helium.desktop";
      "x-scheme-handler/https" = "helium.desktop";
    };
  };
}
