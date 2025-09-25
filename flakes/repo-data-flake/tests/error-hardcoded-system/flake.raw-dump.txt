# tests/error-hardcoded-system/flake.nix
{
  description = "Reproduces: Hardcoded system 'x86_64-linux' causing build failure on 'aarch64-linux'.";

  inputs = {
    nixpkgs.url = "github:meta-introspector/nixpkgs?ref=feature/CRQ-016-nixify";
  };

  outputs = { self, nixpkgs }:
    let
      system = "x86_64-linux"; # Hardcoded system
      pkgs = nixpkgs.legacyPackages.${system};
    in
    {
      packages.${system} = {
        hello = pkgs.hello;
        repo2gramJson = pkgs.runCommand "empty-2gram-json" {} "echo '[]' > $out";
      };
      lib = {
        repoData = []; # Placeholder for repository data
        repoAttrs = {}; # Placeholder for repository attributes
      };
    };
}
