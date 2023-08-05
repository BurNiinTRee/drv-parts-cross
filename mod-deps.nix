{
  config,
  lib,
  dream2nix,
  packageSets,
  ...
}: let
  l = lib // builtins;
  t = l.types;
in {
  imports = [dream2nix.modules.drv-parts.mkDerivation];
  options = {
    nativeBuildInputs' = l.mkOption {
      type = t.listOf t.deferredModule;
      default = [];
    };
    buildInputs' = l.mkOption {
      type = t.listOf t.deferredModule;
      default = [];
    };
  };
  config = {
    mkDerivation = {
      nativeBuildInputs = l.map (mod:
        (l.evalModules {
          modules = [mod dream2nix.modules.drv-parts.core];
          specialArgs.dream2nix = dream2nix;
          specialArgs.packageSets.nixpkgs = packageSets.nixpkgs.pkgsBuildHost;
        })
        .config
        .public)
      config.nativeBuildInputs';
      buildInputs = l.map (mod:
        (l.evalModules {
          modules = [mod dream2nix.modules.drv-parts.core];
          specialArgs.dream2nix = dream2nix;
          specialArgs.packageSets.nixpkgs = packageSets.nixpkgs.pkgsHostTarget;
        })
        .config
        .public)
      config.buildInputs';
    };
  };
}
