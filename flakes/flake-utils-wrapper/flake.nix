{
  description = "A wrapper flake for flake-utils.";

  inputs = {
    flake-utils.url = "github:meta-introspector/flake-utils";
  };

  outputs = { self, flake-utils, ... }:
    flake-utils.lib;
}
