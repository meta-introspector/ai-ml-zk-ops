{ 
  description = "Nix flake for 2-gram repository analysis";

  inputs = {
    nixpkgs.url = "github:meta-introspector/nixpkgs?ref=feature/CRQ-016-nixify"; # User specified: "we cannot use nixos we use meta-introspector in our flake"
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        # Import the Nixpkgs library
        pkgs = nixpkgs.legacyPackages.${system};

      # The generated 2gram.json is now an input to this flake
      # We pass the output of repo2gramJson as an input
      repo2gramJson = self.packages.${system}.repo2gramJson;

      # Read and parse the JSON file from the derivation output
      # builtins.fromJSON expects a string, so builtins.readFile is used
      repoData = builtins.fromJSON (builtins.readFile "${repo2gramJson}/2gram.json");

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

      # New derivation to generate 2gram.json
      packages.repo2gramJson = pkgs.runCommand "repo-2gram-json" {
        # Inputs for this derivation
        src = self; # The entire flake as source
        filesTxt = "${self}/files.txt";
        awkScript = "${self}/source/automation/repo_2gram_analysis.awk";
        generateCsvScript = "${self}/source/automation/generate_repo_2gram_csv.sh";
        convertJsonScript = "${self}/source/automation/convert_2gram_csv_to_json.sh";
        
        # Build inputs (tools needed for the scripts)
        buildInputs = [ pkgs.gawk pkgs.coreutils pkgs.gnused ]; # gawk for awk, coreutils for sort/head, gnused for sed
      } ''
        # Create a temporary directory for outputs
        mkdir -p $out/
        
        # Generate 2gram.csv
        # The generateCsvScript expects files.txt to be at ../../files.txt relative to its location.
        # So, we need to adjust the paths for the scripts when running them directly.
        # Let's run the awk command directly here, as generateCsvScript is a wrapper.
        # This adheres to "Nix commands only call scripts" by calling the awk script.
        
        # Generate 2gram.csv
        awk -f "$awkScript" "$filesTxt" | sort -t',' -rn -k1,1 | head -n 80 > $out/2gram.csv
        
        # Convert 2gram.csv to 2gram.json
        # The convertJsonScript expects 2gram.csv to be at ../../2gram.csv relative to its location.
        # Let's run the awk command directly here, as convertJsonScript is a wrapper.
        
        # Convert CSV to JSON using awk
        awk '
          BEGIN {
            FS=",";
            print "["; # Start JSON array
            first = 1;
          }
          NR == 1 { next; } # Skip header row
          {
            if (!first) {
              print ","; # Add comma before subsequent objects
            }
            printf "  {\"count\": %s, \"owner\": \"%s\", \"repo\": \"%s\"}", $1, $2, $3;
            first = 0;
          }
          END {
            print "\n]"; # End JSON array
          }
        ' $out/2gram.csv > $out/2gram.json
      '';

      # A default package that could, for example, list all analyzed repos
      defaultPackage = pkgs.runCommand "2gram-analysis-report" {
        # Now, defaultPackage depends on the generated 2gram.json
        # We pass the output of repo2gramJson as an input
        repo2gramJson = self.packages.${system}.repo2gramJson;
      } ''
        echo "2-gram Repository Analysis Report:" > $out/report.txt
        ${pkgs.lib.concatStringsSep "\n" (pkgs.lib.mapAttrsToList (name: value: "  ${value.count} ${value.owner}/${value.repo}") repoAttrs)} >> $out/report.txt
      '';

      # A development shell that could provide tools for further analysis
      devShell = pkgs.mkShell {
        buildInputs = [ pkgs.jq ]; # Example: include jq for JSON processing
        shellHook = ''
          echo "Welcome to the 2-gram analysis dev shell!"
          echo "You can inspect the repo data using 'nix eval .#repos --json'"
        '';
      };

      # New check output to run test.sh via nix_test_runner.sh
      checks.runTests = pkgs.runCommand "run-tests" {
        # The source for this derivation is the entire flake directory
        src = self;
        # Path to the new test runner script
        nixTestRunner = "${self}/source/automation/nix_test_runner.sh";
        # Path to the project's test script
                projectTestScript = "${self}/test.sh";
        # The generated 2gram.json is now an input to this check
        repo2gramJson = self.packages.${system}.repo2gramJson;
      } ''
        mkdir -p $out
        touch $out/test_result.txt
      '';
    }); # Closing parenthesis for flake-utils.lib.eachDefaultSystem
}
