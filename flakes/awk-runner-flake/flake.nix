{
  description = "A flake for running awk commands on 2-gram data.";

  inputs = {
    nixpkgs-pinned.url = "path:../../flakes/nixpkgs-pinned";
    flake-utils-wrapper.url = "path:../../flakes/flake-utils-wrapper";
    repo-data-flake.url = "path:../../flakes/repo-data-flake";
  };

  outputs = { nixpkgs-pinned, flake-utils-wrapper, repo-data-flake }:
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