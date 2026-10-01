{ lib }:
lib.evalModules {
  modules = [
    ./types.nix
    ./cv.nix
  ];
}
