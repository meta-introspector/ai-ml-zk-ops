# tests/error-circular-import/flake.nix
{
  description = "Reproduces: Circular import of flake 'path:./.'.";

  inputs = {
    nixpkgs.url = "github:meta-introspector/nixpkgs?ref=feature/CRQ-016-nixify";
    targetRepo.url = "path:./."; # This causes the circular import
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
          # This derivation will trigger the circular import when evaluating targetRepo
          testCircular = pkgs.runCommand "test-circular" {
            src = targetRepo;
          } ''
            echo "This should not be reached" > $out
          '';
        });
    };
}
