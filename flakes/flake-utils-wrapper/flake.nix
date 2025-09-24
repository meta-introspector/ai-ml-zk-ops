{
  description = "A wrapper flake for flake-utils.";

  inputs = {
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { flake-utils, ... }:
    flake-utils;
}