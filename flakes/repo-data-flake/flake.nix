{
  description = "Minimal flake for repo-data-flake.";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs = { self, nixpkgs }: {
    packages.x86_64-linux.hello = nixpkgs.legacyPackages.x86_64-linux.hello;
    lib = {
      repoData = []; # Placeholder for repository data
    };
  };
}
