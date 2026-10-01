{
  description = "kfish.dev";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

  outputs =
    { self, nixpkgs, ... }:
    {
      lib.cv = import ./data { inherit (nixpkgs) lib; };

      checks.x86_64-linux.buildJson = nixpkgs.legacyPackages.x86_64-linux.writeText "cv.json" (
        builtins.toJSON self.lib.cv.config
      );

      formatter.x86_64-linux = nixpkgs.legacyPackages.x86_64-linux.nixfmt-tree;
    };
}
