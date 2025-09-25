# tests/error-each-default-system-missing/flake.nix
{
  description = "Reproduces: 'eachDefaultSystem' attribute missing from nixpkgs.lib.";

  inputs = {
    nixpkgs.url = "github:meta-introspector/nixpkgs?ref=feature/CRQ-016-nixify";
  };

  outputs = { self, nixpkgs }:
    nixpkgs.lib.eachDefaultSystem (system: # This line causes the error
      let
        pkgs = nixpkgs.legacyPackages.${system};
      in
      {
        packages = {
          hello = pkgs.hello;
        };
      }
    );
}
