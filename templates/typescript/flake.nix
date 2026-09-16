{
  description = "TypeScript multi-executable application";
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

  outputs = { nixpkgs, ... }:
    let
      systems = [ "x86_64-linux" "aarch64-linux" "aarch64-darwin" ];
      forAllSystems = nixpkgs.lib.genAttrs systems;
      packageJson = builtins.fromJSON (builtins.readFile ./package.json);
    in {
      packages = forAllSystems (system:
        let pkgs = import nixpkgs { inherit system; };
        in {
          default = (pkgs.buildNpmPackage.override { stdenv = pkgs.stdenvNoCC; }) {
            pname = packageJson.name;
            inherit (packageJson) version;
            src = ./.;
            npmDepsHash = "sha256-ZWWFpc5FTROfZXM9hbDJZFDEkUXp0fEi702efcIpW9s=";
          };
        });

      devShells = forAllSystems (system:
        let pkgs = import nixpkgs { inherit system; };
        in {
          default = pkgs.mkShellNoCC { packages = [ pkgs.nodejs ]; };
        });
    };
}
