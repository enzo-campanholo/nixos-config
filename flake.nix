{
  description = "NixOS config";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";

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
    inputs@{
      home-manager,
      lanzaboote,
      nixpkgs,
      nixpkgs-unstable,
      ...
    }:
    let
      system = "x86_64-linux";

      overlay = final: prev: {
        helium = final.callPackage ./packages/helium.nix { };

        vimPlugins = prev.vimPlugins // {
          vim-selenized = final.callPackage ./packages/vim-selenized.nix { };
        };

        unstable = import nixpkgs-unstable {
          inherit (prev.stdenv.hostPlatform) system;
          inherit (prev) config;
        };
      };
    in
    {
      overlays.default = overlay;

      nixosConfigurations.MONSTRAO = nixpkgs.lib.nixosSystem {
        specialArgs = { inherit inputs; };
        modules = [
          lanzaboote.nixosModules.lanzaboote
          home-manager.nixosModules.home-manager
          { nixpkgs.overlays = [ overlay ]; }
          ./hosts/MONSTRAO
        ];
      };

      packages.${system}.helium = (nixpkgs.legacyPackages.${system}.extend overlay).helium;

      formatter.${system} = nixpkgs.legacyPackages.${system}.nixfmt-tree;
    };
}
