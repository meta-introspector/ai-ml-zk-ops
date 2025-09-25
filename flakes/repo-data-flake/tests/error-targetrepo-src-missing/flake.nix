# tests/error-targetrepo-src-missing/flake.nix
{
  description = "Reproduces: 'src' attribute missing when targetRepo (flake object) is directly assigned to src.";

  inputs = {
    nixpkgs.url = "github:meta-introspector/nixpkgs?ref=feature/CRQ-016-nixify";
    targetRepo.url = "github:meta-introspector/ai-ml-zk-ops?ref=feature/concept-to-nix-8s"; # A valid flake input
  };

  outputs = { self, nixpkgs, targetRepo }:
    let
      systems = [ "x86_64-linux" "aarch64-linux" ];
      forAllSystems = nixpkgs.lib.genAttrs systems;
    in
    {
      packages = forAllSystems (system:
        let
          pkgs = nixpkgs.legacyPackages.${system};
        in
        {
          hello = pkgs.hello;
          # This derivation will trigger the 'src' missing error
          testSrcMissing = pkgs.runCommand "test-src-missing" {
            src = targetRepo; # Incorrect: targetRepo is a flake object, not a source path
          } ''
            echo "This should not be reached" > $out
          '';
        });
    };
}
