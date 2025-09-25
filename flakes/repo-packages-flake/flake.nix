{
  description = "Generates packages for each repository found in repo-data-flake.";

  inputs = {
    nixpkgs-pinned.url = "github:meta-introspector/nixpkgs?ref=feature/CRQ-016-nixify";
    flake-utils-wrapper.url = "github:meta-introspector/ai-ml-zk-ops?dir=flakes/flake-utils-wrapper&ref=feature/concept-to-nix-8s";
    repo-data-flake.url = "github:meta-introspector/ai-ml-zk-ops?dir=flakes/repo-data-flake&ref=feature/concept-to-nix-8s";
  };

  outputs = { self, nixpkgs-pinned, flake-utils-wrapper, repo-data-flake }:
    flake-utils-wrapper.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs-pinned.legacyPackages.${system};
        # traceJson = prefix: value: builtins.trace (prefix + ": " + builtins.toJSON value) {};
        # repoData = traceJson "repoData" repo-data-flake.lib.${system}.repoData;
        repoData = repo-data-flake.repoData; # Modified access
      in
      {
        # Temporarily commented out to debug repoData
        # packages = builtins.listToAttrs (map (item: {
        #   name = "${item.owner}-${item.repo}";
        #   value = pkgs.stdenv.mkDerivation {
        #     pname = "${item.repo}";
        #     version = "unstable"; # Or derive from git tags/commits
        #     src = pkgs.fetchFromGitHub {
        #       owner = item.owner;
        #       repo = item.repo;
        #       ref = "feature/CRQ-016-nixify"; # Using the specified ref
        #       # sha256 = "sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA="; # Placeholder, needs to be updated
        #     };
        #     dontBuild = true;
        #     dontInstall = true;
        #   };
        # }) repoData);

        devShells.default = pkgs.mkShell {
          packages = with pkgs; [
          ];
          
        };

        packages.dummy = pkgs.stdenv.mkDerivation {
          pname = "dummy-package";
          version = "1.0";
          src = pkgs.lib.cleanSource ./.;
          installPhase = "mkdir -p $out/bin; echo 'Hello from dummy' > $out/bin/dummy";
        };
        repoData = repoData; # Expose repoData for inspection
      }
    );

}
