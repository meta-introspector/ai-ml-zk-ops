# tests/error-script-not-found/flake.nix
{
  description = "Reproduces: 'chmod: cannot access ... No such file or directory' when script is not found.";

  inputs = {
    nixpkgs.url = "github:meta-introspector/nixpkgs?ref=feature/CRQ-016-nixify";
  };

  outputs = { self, nixpkgs }:
    let
      systems = [ "x86_64-linux" "aarch64-linux" ];
      forAllSystems = nixpkgs.lib.genAttrs systems;
    in
    {
      packages = forAllSystems (system:
        let
          pkgs = nixpkgs.legacyPackages.${system};
          # This path will likely not exist in the build environment
          nonExistentScript = self.outPath + "/non-existent-path/non-existent-script.sh";
        in
        {
          hello = pkgs.runCommand "hello-script-not-found" {
            buildInputs = [ pkgs.bash ];
          } ''
            chmod +x ${nonExistentScript} || true # Use || true to prevent build failure from chmod
            ${nonExistentScript} || true # Use || true to prevent build failure from script execution
            echo "Attempted to access non-existent script" > $out
          '';
        });
    };
}
