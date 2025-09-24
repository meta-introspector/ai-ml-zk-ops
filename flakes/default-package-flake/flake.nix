{ 
description = "Provides the default 2-gram analysis report package.";

  inputs = { 
    nixpkgs-pinned.url = "path:../nixpkgs-pinned";
    flake-utils-wrapper.url = "path:../flake-utils-wrapper";
    repo-data-flake.url = "path:../repo-data-flake";
  };

  outputs = { nixpkgs-pinned, flake-utils-wrapper, repo-data-flake }:
    flake-utils-wrapper.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs-pinned.legacyPackages.${system};
        repoAttrs = repo-data-flake.lib.${system}.repoAttrs;
        repo2gramJson = repo-data-flake.packages.${system}.repo2gramJson;
      in
      {
        packages.default = pkgs.runCommand "2gram-analysis-report" { 
          repo2gramJson = repo2gramJson;
        }
        ''
          echo "2-gram Repository Analysis Report:" > $out/report.txt
          ${pkgs.lib.concatStringsSep "\n" (pkgs.lib.mapAttrsToList (name: value: "  ${value.count} ${value.owner}/${value.repo}") repoAttrs)} >> $out/report.txt
        '';
      }
    );
}