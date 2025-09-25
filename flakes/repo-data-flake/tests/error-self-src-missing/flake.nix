# tests/error-self-src-missing/flake.nix
{
  description = "Reproduces: 'self.src' attribute missing when used to reference a script.";

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
          # This line causes the 'self.src' missing error
          testScript = self.src + "/non-existent-script.sh";
        in
        {
          hello = pkgs.runCommand "hello-with-missing-src" {
            buildInputs = [ pkgs.bash ];
          } ''
            echo "Attempting to use script from: ${testScript}" > $out
          '';
        });
    };
}
