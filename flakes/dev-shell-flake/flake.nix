{
  description = "Provides a development shell for 2-gram analysis.";

  inputs = {
    nixpkgs-pinned.url = "github:meta-introspector/ai-ml-zk-ops?dir=flakes/nixpkgs-pinned&ref=feature/concept-to-nix-8s";
    flake-utils-wrapper.url = "github:meta-introspector/ai-ml-zk-ops?dir=flakes/flake-utils-wrapper&ref=feature/concept-to-nix-8s";
    repo-data-flake.url = "github:meta-introspector/ai-ml-zk-ops?dir=flakes/repo-data-flake&ref=feature/concept-to-nix-8s";
  };

  outputs = { nixpkgs-pinned, flake-utils-wrapper, repo-data-flake }:
    flake-utils-wrapper.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs-pinned.legacyPackages.${system};
        repo2gramJson = repo-data-flake.packages.${system}.repo2gramJson;
      in
      {
        devShell = pkgs.mkShell {
          buildInputs = [ pkgs.jq ]; # Example: include jq for JSON processing
          shellHook = ''
            echo "Welcome to the 2-gram analysis dev shell!"
            echo "You can inspect the repo data using 'nix eval .#repos --json'"
            echo "The 2-gram JSON is available at ${repo2gramJson}/2gram.json"
          '';
        };
      }
    );
}