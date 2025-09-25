# flakes/add-2gram-script/flake.nix
{
  description = "Adds the generate-2-gram.sh script as a separate derivation.";

  inputs = {
    nixpkgs.url = "github:meta-introspector/nixpkgs?ref=feature/CRQ-016-nixify";
    addRepoDataLib.url = "github:meta-introspector/ai-ml-zk-ops?ref=feature/concept-to-nix-8s&dir=flakes/repo-data-flake/flakes/add-repo-data-lib"; # Input from the previous flake
    repoDataFlakeRoot.url = "github:meta-introspector/ai-ml-zk-ops?ref=feature/concept-to-nix-8s&dir=flakes/repo-data-flake"; # Input for the root of repo-data-flake to get the script
  };

  outputs = { self, nixpkgs, addRepoDataLib, repoDataFlakeRoot }:
    let
      systems = [ "x86_64-linux" "aarch64-linux" ];
      forAllSystems = nixpkgs.lib.genAttrs systems;
    in
    {
      src = ./.;
      # Inherit packages and lib from addRepoDataLib
      packages = addRepoDataLib.packages // forAllSystems (system:
        let
          pkgs = nixpkgs.legacyPackages.${system};
          # Create a derivation for the script itself
          generate2GramScriptDerivation = pkgs.runCommand "generate-2-gram-script" {
            # Pass the script as a source input to this derivation
            src = repoDataFlakeRoot.src + "/scripts/generate-2-gram.sh"; # Reference the script from repoDataFlakeRoot
          } ''
            cp $src $out
            chmod +x $out
          '';
        in
        {
          # Expose the script derivation
          generate2GramScript = generate2GramScriptDerivation;
        }
      );
      lib = addRepoDataLib.lib; # Inherit lib from addRepoDataLib
    };
}
