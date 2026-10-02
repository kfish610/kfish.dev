{
  description = "kfish.dev";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    git-hooks = {
      url = "github:cachix/git-hooks.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      nixpkgs,
      git-hooks,
      ...
    }:
    let
      pkgs = nixpkgs.legacyPackages.x86_64-linux;
      nodejs = pkgs.nodejs_24;

      hooks = git-hooks.lib.x86_64-linux.run {
        src = ./.;
        hooks = {
          nixfmt.enable = true;
          statix.enable = true;
          deadnix.enable = true;

          check-added-large-files.enable = true;
          check-case-conflicts.enable = true;
          check-merge-conflicts.enable = true;
          detect-private-keys.enable = true;

          prettier = {
            enable = true;
            package = null;
            settings.binPath = "./node_modules/.bin/prettier";
          };
          eslint = {
            enable = true;
            package = null;
            settings = {
              binPath = "./node_modules/.bin/eslint";
              extensions = "\\.(js|ts|svelte)$";
            };
          };
          verify = {
            enable = true;
            name = "npm run verify";
            entry = "${nodejs}/bin/npm run verify";
            pass_filenames = false;
            always_run = true;
            stages = [ "pre-push" ];
          };
        };
      };
    in
    {
      lib.cv = import ./data { inherit (nixpkgs) lib; };

      formatter.x86_64-linux = pkgs.nixfmt-tree;

      devShells.x86_64-linux.default = pkgs.mkShellNoCC {
        packages = [
          nodejs
          pkgs.nixd
        ]
        ++ hooks.enabledPackages;
        inherit (hooks) shellHook;
      };
    };
}
