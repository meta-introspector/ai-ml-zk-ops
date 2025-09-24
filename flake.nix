{
  description = "Nix flake for 2-gram repository analysis (composed from smaller flakes).";

  inputs = {
    flake-utils-wrapper.url = "./flakes/flake-utils-wrapper";
    nixpkgs-pinned.url = "./flakes/nixpkgs-pinned";
    repo-data-flake.url = "./flakes/repo-data-flake";
    repo-packages-flake.url = "./flakes/repo-packages-flake";
    awk-runner-flake.url = "./flakes/awk-runner-flake";
    default-package-flake.url = "./flakes/default-package-flake";
    dev-shell-flake.url = "./flakes/dev-shell-flake";
  };

  outputs = { self, flake-utils-wrapper, nixpkgs-pinned, repo-data-flake, repo-packages-flake, awk-runner-flake, default-package-flake, dev-shell-flake }:
    flake-utils-wrapper.eachDefaultSystem (system, _self:
      let
        pkgs = nixpkgs-pinned.legacyPackages.${system};
        repoAttrs = repo-data-flake.lib.${system}.repoAttrs;
      in
      {
        # Expose the generated repository attributes
        repos = repoAttrs;

        # Expose packages from repo-packages-flake, default-package-flake, and repo-data-flake
        packages = repo-packages-flake.packages.${system} // {
          inherit (repo-data-flake.packages.${system}) repo2gramJson;
          inherit (default-package-flake.packages.${system}) default;
        };

        # Expose apps from awk-runner-flake
        apps = awk-runner-flake.apps.${system};

        # Expose the devShell from dev-shell-flake
        devShell = dev-shell-flake.devShell.${system};

        # New check output to run test.sh via nix_test_runner.sh
        checks.runTests = pkgs.runCommand "run-tests" {
          # The source for this derivation is the entire flake directory
          src = self;
          # Path to the new test runner script
          nixTestRunner = "${self}/source/automation/nix_test_runner.sh";
          # Path to the project's test script
          projectTestScript = "${self}/test.sh";
          # The generated 2gram.json is now an input to this check
          repo2gramJson = repo-data-flake.packages.${system}.repo2gramJson;
        } ''
          mkdir -p $out
          touch $out/test_result.txt
        '';
      }
    );
}