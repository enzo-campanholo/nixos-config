{
  description = "OCaml development environment";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";

  outputs =
    { nixpkgs, ... }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
      ocamlPackages = pkgs.ocaml-ng.ocamlPackages_5_4;
    in
    {
      devShells.${system}.default = pkgs.mkShell {
        packages = [
          ocamlPackages.ocaml
          ocamlPackages.dune_3
          ocamlPackages.findlib
          ocamlPackages.ocaml-lsp
          ocamlPackages.ocamlformat_0_29_0
          ocamlPackages.odoc
          ocamlPackages.utop
        ];
      };
    };
}
