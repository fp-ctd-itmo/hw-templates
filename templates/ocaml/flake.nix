{
  description = "OCaml multi-executable application";
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

  outputs = { nixpkgs, ... }:
    let
      systems = [
        "x86_64-linux"
        "aarch64-linux"
        "x86_64-darwin"
        "aarch64-darwin"
      ];
      forAllSystems = nixpkgs.lib.genAttrs systems;
    in {
      packages = forAllSystems (system:
        let
          pkgs = import nixpkgs { inherit system; };
          ocaml = pkgs.ocamlPackages;
        in {
          # Dune is the source of truth for executable targets. Public
          # executables are installed by Dune into $out/bin.
          default = ocaml.buildDunePackage {
            pname = "student_apps";
            version = "0.1.0";
            src = ./.;
            duneVersion = "3";
          };
        });

      devShells = forAllSystems (system:
        let pkgs = import nixpkgs { inherit system; };
        in {
          default = pkgs.mkShell {
            packages = [
              pkgs.ocamlPackages.ocaml
              pkgs.ocamlPackages.dune_3
              pkgs.ocamlPackages.ocaml-lsp
            ];
          };
        });
    };
}
