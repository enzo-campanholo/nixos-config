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
    file.".XCompose".text = ''
      include "%L"

      <dead_acute> <c> : "ç" U00E7
      <dead_acute> <C> : "Ç" U00C7
    '';
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

    fish = {
      enable = true;
      functions.fish_greeting = "";
    };

    ghostty = {
      enable = true;
      settings = {
        command = lib.getExe pkgs.fish;
        theme = "Selenized Black";
      };
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
      plugins = [ pkgs.vimPlugins.vim-selenized ];
      initLua = ''
        vim.opt.number = true
        vim.opt.relativenumber = true

        vim.opt.termguicolors = true
        vim.opt.background = "dark"
        vim.cmd.colorscheme("selenized_bw")
      '';
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

    "org/gnome/desktop/session".idle-delay = lib.gvariant.mkUint32 0;

    "org/gnome/settings-daemon/plugins/power" = {
      idle-dim = false;
      sleep-inactive-ac-timeout = lib.gvariant.mkInt32 0;
      sleep-inactive-ac-type = "nothing";
      sleep-inactive-battery-timeout = lib.gvariant.mkInt32 0;
      sleep-inactive-battery-type = "nothing";
    };
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
