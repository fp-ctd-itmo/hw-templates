{
  description = "JavaScript multi-executable application";
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
      packageJson = builtins.fromJSON (builtins.readFile ./package.json);
      binEntries = packageJson.bin or { };
      binNames = builtins.attrNames binEntries;
      validBinName = name:
        builtins.match "^[A-Za-z0-9][A-Za-z0-9._+-]*$" name != null;
      invalidBinNames = builtins.filter (name: !validBinName name) binNames;
    in {
      packages = forAllSystems (system:
        let
          pkgs = import nixpkgs { inherit system; };
          lib = pkgs.lib;
          installWrappers = lib.concatMapStringsSep "\n" (name:
            let script = binEntries.${name};
            in ''
              name=${lib.escapeShellArg name}
              script=${lib.escapeShellArg script}
              test -f "$out/lib/student-apps/$script" || {
                echo "package.json bin entry '$name' points to missing file: $script" >&2
                exit 1
              }
              makeWrapper ${pkgs.nodejs}/bin/node "$out/bin/$name" \
                --add-flags "$out/lib/student-apps/$script"
            '') binNames;
        in {
          default =
            assert lib.assertMsg (invalidBinNames == [ ])
              "package.json bin names must match ^[A-Za-z0-9][A-Za-z0-9._+-]*$";
            pkgs.stdenvNoCC.mkDerivation {
              pname = "student-apps";
              version = "0.1.0";
              src = ./.;
              nativeBuildInputs = [ pkgs.makeWrapper ];
              dontBuild = true;

              installPhase = ''
                runHook preInstall
                mkdir -p "$out/bin" "$out/lib/student-apps"
                cp -R . "$out/lib/student-apps"
                ${installWrappers}
                runHook postInstall
              '';
            };
        });

      devShells = forAllSystems (system:
        let pkgs = import nixpkgs { inherit system; };
        in {
          default = pkgs.mkShell {
            packages = [ pkgs.nodejs ];
          };
        });
    };
}
