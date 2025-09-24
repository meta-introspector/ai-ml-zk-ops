{
  description = "Test case for 'attribute lib missing' error in repo-data-flake.";

  inputs = {
    repo-data-flake.url = "./flakes/repo-data-flake";
  };

  outputs = { repo-data-flake }: {
    checks.x86_64-linux.testLibAttribute =
      if builtins.hasAttr "lib" repo-data-flake
      then "lib attribute found in repo-data-flake"
      else throw "Error: attribute 'lib' missing in repo-data-flake";
  };
}