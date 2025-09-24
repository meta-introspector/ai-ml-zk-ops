{
  description = "Generates packages for each repository found in repo-data-flake.";

  inputs = {
    nixpkgs-pinned.url = "path:../nixpkgs-pinned";
    flake-utils-wrapper.url = "path:../flake-utils-wrapper";
    repo-data-flake.url = "path:../repo-data-flake";
  };

  outputs = { nixpkgs-pinned, flake-utils-wrapper, repo-data-flake }:
    flake-utils-wrapper.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs-pinned.legacyPackages.${system};
        repoData = repo-data-flake.lib.${system}.repoData;
      in
      {
        packages = builtins.listToAttrs (map (item: {
          name = "${item.owner}-${item.repo}";
          value = pkgs.stdenv.mkDerivation {
            pname = "${item.repo}";
            version = "unstable"; # Or derive from git tags/commits
            src = pkgs.fetchFromGitHub {
              owner = item.owner;
              repo = item.repo;
              ref = "feature/CRQ-016-nixify"; # Using the specified ref
              # sha256 = "sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA="; # Placeholder, needs to be updated
            };
            dontBuild = true;
            dontInstall = true;
          };
        }) repoData);
      }
    );
}
