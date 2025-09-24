{
  description = "Generates 2-gram repository data from project files.";

  inputs = {
    nixpkgs-pinned.url = "path:../nixpkgs-pinned";
    flake-utils-wrapper.url = "path:../flake-utils-wrapper";
    self.flake = false; # This flake doesn't need to be a flake itself
  };

  outputs = { self, nixpkgs-pinned, flake-utils-wrapper }:
    flake-utils-wrapper.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs-pinned.legacyPackages.${system};

        # The generated 2gram.json is now an input to this flake
        repo2gramJson = pkgs.runCommand "repo-2gram-json" {
          # Inputs for this derivation
          src = ../..; # The entire main project as source
          filesTxt = "${self.src}/files.txt";
          awkScript = "${self.src}/source/automation/repo_2gram_analysis.awk";
          generateCsvScript = "${self.src}/source/automation/generate_repo_2gram_csv.sh";
          # New input for the JSON conversion awk script
          convertJsonAwkScript = "${self.src}/source/automation/convert_2gram_csv_to_json.awk";

          # Build inputs (tools needed for the scripts)
          buildInputs = [ pkgs.gawk pkgs.coreutils pkgs.gnused ]; # gawk for awk, coreutils for sort/head, gnused for sed
        } ''
          # Create a temporary directory for outputs
          mkdir -p $out/

          # Generate 2gram.csv
          awk -f "$awkScript" "$filesTxt" | sort -t',' -rn -k1,1 | head -n 80 > $out/2gram.csv

          # Convert 2gram.csv to 2gram.json using the new script
          ${pkgs.gawk}/bin/awk -f "$convertJsonAwkScript" $out/2gram.csv > $out/2gram.json
        '';

        # Read and parse the JSON file from the derivation output
        repoData = builtins.fromJSON (builtins.readFile "${repo2gramJson}/2gram.json");

        # Function to convert a single repo entry into a Nix attribute set
        mkRepoAttr = { count, owner, repo }: { inherit count owner repo; };

        # Convert the list of repo data into an attribute set
        repoAttrs = builtins.listToAttrs (map (item: { name = "${item.owner}-${item.repo}"; value = mkRepoAttr item; }) repoData);
      in
      {
        packages.repo2gramJson = repo2gramJson; # Expose repoData and repoAttrs for other flakes to consume
        lib.repoData = repoData;
        lib.repoAttrs = repoAttrs;
      }
    );
}