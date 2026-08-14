{
  description = "MONSTRAO";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";

    helium.url = "github:schembriaiden/helium-browser-nix-flake";

    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    lanzaboote = {
      url = "github:nix-community/lanzaboote/v1.1.0";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      helium,
      home-manager,
      lanzaboote,
      nixpkgs,
      nixpkgs-unstable,
      ...
    }:
    {
      templates = {
        ocaml = {
          path = ./templates/ocaml;
          description = "OCaml 5 development shell";
        };
        prolog = {
          path = ./templates/prolog;
          description = "Scryer Prolog development shell";
        };
      };

      nixosConfigurations.MONSTRAO = nixpkgs.lib.nixosSystem {
        modules = [
          ./configuration.nix
          lanzaboote.nixosModules.lanzaboote
          home-manager.nixosModules.home-manager
          (
            { config, ... }:
            {
              home-manager = {
                useGlobalPkgs = true;
                useUserPackages = true;
                backupFileExtension = "backup";
                extraSpecialArgs = {
                  inherit helium;
                  pkgsUnstable = import nixpkgs-unstable {
                    inherit (config.nixpkgs.hostPlatform) system;
                    inherit (config.nixpkgs) config overlays;
                  };
                };
                users.isolino = ./home.nix;
              };
            }
          )
        ];
      };
    };
}
