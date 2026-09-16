{
  description = "Scala multi-executable application";
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

  outputs = { self, nixpkgs }:
    let

      systems = [
        "x86_64-linux"
        "aarch64-linux"
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
          default = pkgs.stdenvNoCC.mkDerivation {
            pname = "student-apps";
            version = "0.1.0";
            src = ./.;
            nativeBuildInputs = [ pkgs.jdk21 pkgs.scala_3 pkgs.makeWrapper ];

            buildPhase = ''
              runHook preBuild
              mkdir -p build/classes
              for name in ${executableArgs}; do
                test -f "apps/$name/Main.scala" || { echo "missing apps/$name/Main.scala" >&2; exit 1; }
                mkdir -p "build/classes/$name"
                scalac -release 21 -d "build/classes/$name" apps/"$name"/*.scala
              done
              runHook postBuild
            '';

            installPhase = ''
              runHook preInstall
              mkdir -p "$out/bin" "$out/lib/student-apps"
              for name in ${executableArgs}; do
                cp -R "build/classes/$name" "$out/lib/student-apps/$name"
                makeWrapper ${pkgs.jdk21}/bin/java "$out/bin/$name" \
                  --add-flags "-cp $out/lib/student-apps/$name:${pkgs.scala_3.bare}/lib/* Main"
              done
              runHook postInstall
            '';
          };
        });


      devShells = forAllSystems (system:
        let pkgs = import nixpkgs { inherit system; };
        in { default = pkgs.mkShell { packages = [ pkgs.jdk21 pkgs.scala_3 ]; }; });
    };
}
