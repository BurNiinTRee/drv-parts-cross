{
  config,
  lib,
  drv-parts,
  specialArgs,
  ...
}: let
  l = lib // builtins;
  t = l.types;
in {
  imports = [drv-parts.modules.drv-parts.mkDerivation];
  options = {
    nativeBuildInputs' = l.mkOption {
      type = t.listOf t.raw;
      default = [];
    };
    buildInputs' = l.mkOption {
      type = t.listOf t.raw;
      default = [];
    };
  };
  config = {
    mkDerivation = {
      nativeBuildInputs = l.map (mod:
        (mod.extendModules {
          specialArgs = lib.recursiveUpdateUntil (path: l: r: path == ["packageSets" "nixpkgs"]) specialArgs {packageSets.nixpkgs = specialArgs.packageSets.nixpkgs.pkgsBuildHost;};
        })
        .config
        .public)
      config.nativeBuildInputs';
      buildInputs = l.map (mod:
        (mod.extendModules {
          specialArgs = lib.recursiveUpdateUntil (path: l: r: path == ["packageSets" "nixpkgs"]) specialArgs {packageSets.nixpkgs = specialArgs.packageSets.nixpkgs.pkgsHostTarget;};
        })
        .config
        .public)
      config.buildInputs';
    };
  };
}
