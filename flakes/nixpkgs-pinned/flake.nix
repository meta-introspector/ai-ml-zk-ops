{
  description = "A pinned nixpkgs flake.";

  inputs = {
    nixpkgs.url = "github:meta-introspector/nixpkgs?ref=feature/CRQ-016-nixify";
  };

  outputs = { nixpkgs, ... }:
    { 
      legacyPackages = nixpkgs.legacyPackages;
      lib = nixpkgs.lib;
    };
}