{
  description = "Minimal flake for repo-data-flake.";

  inputs = {
    nixpkgs.url = "github:meta-introspector/nixpkgs?ref=feature/CRQ-016-nixify";
    targetRepo.url = "github:meta-introspector/ai-ml-zk-ops?ref=feature/concept-to-nix-8s";
  };

  outputs = { self, nixpkgs, targetRepo }:
    let
      systems = [ "x86_64-linux" "aarch64-linux" ];
      forAllSystems = nixpkgs.lib.genAttrs systems;
    in
    {
      src = ./.;
      packages = forAllSystems (system:
        let
          pkgs = nixpkgs.legacyPackages.${system};
          # Create a derivation for the script itself
          generate2GramScriptDerivation = pkgs.runCommand "generate-2-gram-script" {
            # Pass the script as a source input to this derivation
            src = self.src + "/scripts/generate-2-gram.sh";
          } ''
            cp $src $out
            chmod +x $out
          '';
        in
        {
          hello = pkgs.hello;
          repo2gramJson = pkgs.runCommand "repo-2gram-json" {
            buildInputs = [ pkgs.jq ]; # Ensure jq is available
            src = targetRepo.outPath; # The input repository's source path
          } ''
            ${generate2GramScriptDerivation} $src $out
          '';
        });
      lib = {
        repoData = []; # Placeholder for repository data
        repoAttrs = {}; # Placeholder for repository attributes
      };
      flakes = {
        add-2gram-script = import ./flakes/add-2gram-script;
        add-repo-data-lib = import ./flakes/add-repo-data-lib;
        base-flake = import ./flakes/base-flake;
        error-circular-import = import ./tests/error-circular-import;
        error-each-default-system-missing = import ./tests/error-each-default-system-missing;
        error-hardcoded-system = import ./tests/error-hardcoded-system;
        error-script-not-found = import ./tests/error-script-not-found;
        error-self-src-missing = import ./tests/error-self-src-missing;
        error-system-duplicate-packages = import ./tests/error-system-duplicate-packages;
        error-targetrepo-src-missing = import ./tests/error-targetrepo-src-missing;
      };
    };
}