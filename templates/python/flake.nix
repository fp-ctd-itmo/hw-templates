{
  description = "Python multi-executable application";
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
          py = pkgs.python3Packages;
        in {
          # pyproject.toml is the source of truth. Every [project.scripts]
          # entry becomes a command in $out/bin.
          default = py.buildPythonApplication {
            pname = "student-apps";
            version = "0.1.0";
            src = ./.;
            pyproject = true;
            build-system = [ py.setuptools ];
          };
        });

      devShells = forAllSystems (system:
        let pkgs = import nixpkgs { inherit system; };
        in {
          default = pkgs.mkShell {
            packages = [ pkgs.python3 pkgs.python3Packages.setuptools ];
          };
        });
    };
}
