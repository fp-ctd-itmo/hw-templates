{
  description = "Haskell multi-executable application";
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
        let pkgs = import nixpkgs { inherit system; };
        in {
          # Cabal is the source of truth. Every public `executable` stanza in
          # student-apps.cabal is built and installed into $out/bin.
          default = pkgs.haskellPackages.callCabal2nix "student-apps" ./. { };
        });

      devShells = forAllSystems (system:
        let pkgs = import nixpkgs { inherit system; };
        in {
          default = pkgs.mkShell {
            packages = [
              pkgs.haskellPackages.ghc
              pkgs.cabal-install
              pkgs.haskell-language-server
            ];
          };
        });
    };
}
