{
  description = "A flake for running awk commands on 2-gram data.";

  inputs = {
    # These inputs are defined in the main flake and passed down.
    # We use placeholder URLs here, which will be overridden by the main flake.
    # This allows the flake to be self-contained if built in isolation,
    # but correctly integrated into the monorepo.
    nixpkgs-pinned.url = "github:NixOS/nixpkgs/nixos-unstable"; # Placeholder
    flake-utils-wrapper.url = "github:numtide/flake-utils"; # Placeholder
    repo-data-flake.url = "path:./."; # Placeholder (points to itself, will be overridden)
  };

  outputs = { self, nixpkgs-pinned, flake-utils-wrapper, repo-data-flake } @ inputs:
    flake-utils-wrapper.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs-pinned.legacyPackages.${system};
        repo2gramJson = repo-data-flake.packages.${system}.repo2gramJson;
      in
      {
        apps.default = {
          type = "app";
          program = "${pkgs.writeShellScript "awk-runner" ''
            ${pkgs.gawk}/bin/awk -f ${repo-data-flake.src}/source/automation/repo_2gram_analysis.awk ${repo-data-flake.src}/files.txt
          ''}";
        };

        devShell = pkgs.mkShell {
          buildInputs = [ pkgs.gawk pkgs.jq ];
          shellHook = ''
            echo "Welcome to the awk-runner dev shell!"
            echo "You can access the 2-gram JSON at ${repo2gramJson}/2gram.json"
            echo "Example: jq . ${repo2gramJson}/2gram.json"
          '';
        };
      }
    );
}