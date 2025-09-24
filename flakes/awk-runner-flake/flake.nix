{
  description = "A flake for running awk commands on 2-gram data.";

  inputs = {
    # All inputs must be remote github:meta-introspector URLs.
    nixpkgs-pinned.url = "github:meta-introspector/nixpkgs?ref=feature/CRQ-016-nixify";
    flake-utils-wrapper.url = "github:meta-introspector/flake-utils?ref=feature/CRQ-016-nixify";
    repo-data-flake.url = "github:meta-introspector/ai-ml-zk-ops?ref=feature/concept-to-nix-8s";
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