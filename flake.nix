{ 
  description = "Nix flake for 2-gram repository analysis";

  inputs = {
    nixpkgs.url = "github:meta-introspector/nixpkgs?ref=feature/CRQ-016-nixify"; # User specified: "we cannot use nixos we use meta-introspector in our flake"
  };

  outputs = { self, nixpkgs }:
    let
      # Import the Nixpkgs library
      pkgs = nixpkgs.legacyPackages.${builtins.currentSystem};

      # Path to the generated 2gram.json file
      # Assuming 2gram.json is in the same directory as flake.nix
      jsonFile = ./2gram.json;

      # Read and parse the JSON file
      # builtins.fromJSON expects a string, so builtins.readFile is used
      repoData = builtins.fromJSON (builtins.readFile jsonFile);

      # Function to convert a single repo entry into a Nix attribute set
      # This function takes an object { count, owner, repo }
      # and returns an attribute set like { count = 10; owner = "NixOS"; repo = "nixpkgs"; }
      mkRepoAttr = { count, owner, repo }:
        {
          inherit count owner repo;
          # You could add more complex derivations here, e.g.,
          # package = pkgs.stdenv.mkDerivation {
          #   pname = "${owner}-${repo}";
          #   version = "0.1.0";
          #   src = pkgs.fetchFromGitHub {
          #     inherit owner repo;
          #     rev = "master"; # Or a specific commit/tag
          #     sha256 = "sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=";
          #   };
          #   # ... other build instructions
          # };
        };

      # Convert the list of repo data into an attribute set
      # The key for each attribute will be "${owner}-${repo}"
      repoAttrs = builtins.listToAttrs (map (item: { 
        name = "${item.owner}-${item.repo}";
        value = mkRepoAttr item;
      }) repoData);

    in {
      # Expose the generated repository attributes
      # You can access these via `nix build .#repos.NixOS-nixpkgs` for example
      repos = repoAttrs;

      # A default package that could, for example, list all analyzed repos
      defaultPackage.${builtins.currentSystem} = pkgs.runCommand "2gram-analysis-report" {} ''
        echo "2-gram Repository Analysis Report:" > $out/report.txt
        ${pkgs.lib.concatStringsSep "\n" (pkgs.lib.mapAttrsToList (name: value: "  ${value.count} ${value.owner}/${value.repo}") repoAttrs)} >> $out/report.txt
      '';

      # A development shell that could provide tools for further analysis
      devShell.${builtins.currentSystem} = pkgs.mkShell {
        buildInputs = [ pkgs.jq ]; # Example: include jq for JSON processing
        shellHook = ''
          echo "Welcome to the 2-gram analysis dev shell!"
          echo "You can inspect the repo data using 'nix eval .#repos --json'"
        '';
      };

      # New check output to run test.sh via nix_test_runner.sh
      checks.${builtins.currentSystem}.runTests = pkgs.runCommand "run-tests" {
        # The source for this derivation is the entire flake directory
        src = self;
        # Path to the new test runner script
        nixTestRunner = "${self}/source/automation/nix_test_runner.sh";
        # Path to the project's test script
        projectTestScript = "${self}/test.sh";
      }
        ''
        # Call the nixTestRunner script with the project's test script and the output log path
        "$nixTestRunner" "$projectTestScript" "$out/test_output.log"
      '';
    };
}
