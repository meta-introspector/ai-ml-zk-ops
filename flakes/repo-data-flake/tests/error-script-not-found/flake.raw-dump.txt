# tests/error-script-not-found/flake.nix
{
  description = "Reproduces: 'chmod: cannot access ... No such file or directory' when script is not found.";

  inputs = {
    nixpkgs.url = "github:meta-introspector/nixpkgs?ref=feature/CRQ-016-nixify";
  };

  outputs = { self, nixpkgs }:
    let
      systems = [ "x86_64-linux" "aarch64-linux" ];
      forAllSystems = nixpkgs.lib.genAttrs systems;
    in
    {
      src = ./.;
      packages = forAllSystems (system:
        let
          pkgs = nixpkgs.legacyPackages.${system};
          # This path will now exist
          testScript = self.src + "/dummy-script.sh";
        in
        {
          hello = pkgs.runCommand "hello-script-not-found" {
            buildInputs = [ pkgs.bash ];
          } ''
            chmod +x ${testScript}
            ${testScript}
            echo "Successfully accessed dummy script" > $out
          '';
        });
    };
}
