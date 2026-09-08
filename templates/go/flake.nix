{
  description = "Go multi-executable application";
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
          default = pkgs.buildGoModule {
            pname = "student-apps";
            version = "0.1.0";
            src = ./.;

            # Go natively supports multiple commands. Add each command as a
            # package below cmd/, e.g. cmd/foo and cmd/bar. The Go package
            # pattern makes buildGoModule build/install all of them.
            subPackages = [ "cmd/..." ];

            # This project has no third-party modules. If dependencies are
            # added to go.mod, replace null with the vendor hash reported by Nix.
            vendorHash = null;
          };
        });

      devShells = forAllSystems (system:
        let pkgs = import nixpkgs { inherit system; };
        in {
          default = pkgs.mkShell {
            packages = [ pkgs.go ];
          };
        });
    };
}
