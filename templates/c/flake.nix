{
  description = "C multi-executable application";
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

  outputs = { self, nixpkgs }:
    let

      systems = [
        "x86_64-linux"
        "aarch64-linux"
        "x86_64-darwin"
        "aarch64-darwin"
      ];
      forAllSystems = nixpkgs.lib.genAttrs systems;
      appEntries = builtins.readDir ./apps;
      executableNames = builtins.attrNames (
        nixpkgs.lib.filterAttrs (_: kind: kind == "directory") appEntries
      );
      validExecutableName = name:
        builtins.match "^[A-Za-z0-9][A-Za-z0-9._+-]*$" name != null;
      invalidExecutableNames = builtins.filter (name: !validExecutableName name) executableNames;
      checkedExecutableNames =
        assert nixpkgs.lib.assertMsg (invalidExecutableNames == [ ])
          "Executable directory names must match ^[A-Za-z0-9][A-Za-z0-9._+-]*$";
        executableNames;
      executableArgs = nixpkgs.lib.escapeShellArgs checkedExecutableNames;
    in {
      packages = forAllSystems (system:
        let pkgs = import nixpkgs { inherit system; };
        in {
          default = pkgs.stdenv.mkDerivation {
            pname = "student-apps";
            version = "0.1.0";
            src = ./.;

            buildPhase = ''
              runHook preBuild
              mkdir -p build
              for name in ${executableArgs}; do
                sources=(apps/"$name"/*.c)
                if [ "''${#sources[@]}" -eq 0 ]; then
                  echo "apps/$name contains no .c files" >&2
                  exit 1
                fi
                "$CC" -std=c17 -O2 -Wall -Wextra "''${sources[@]}" -o "build/$name"
              done
              runHook postBuild
            '';

            installPhase = ''
              runHook preInstall
              mkdir -p "$out/bin"
              for name in ${executableArgs}; do
                install -m755 "build/$name" "$out/bin/$name"
              done
              runHook postInstall
            '';
          };
        });


      devShells = forAllSystems (system:
        let pkgs = import nixpkgs { inherit system; };
        in { default = pkgs.mkShell { packages = [ pkgs.clang ]; }; });
    };
}
