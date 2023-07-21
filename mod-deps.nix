{config, lib, drv-parts, specialArgs, ...}:
let l = lib // builtins;
in{
  imports = [ drv-parts.modules.drv-parts.mkDerivation];
  options = {
    depsMod = l.mkOption {
      type = l.attrsOf l.deferredModule;
    };
    nativeBuildInputs' = l.mkOption {
      type = l.listOf l.deferredModule;
      default = [];
    };
    buildInputs' = l.mkOption {
      type = l.listOf l.deferredModule;
      default = [];
    };
  };
  config = {
    depsMod = l.mapAttrs (_: drv-parts.lib.makeModule) config.deps;
    nativeBuildInputs = l.map (mod: l.evalModules {
      modules = [mod];
      specialArgs = lib.recursiveUpdateUntil (path: l: r: (lib.traceVal path) == ["dependencySets" "nixpkgs"]) specialArgs {dependencySets.nixpkgs = specialArgs.dependencySets.nixpkgs.pkgsBuildHost;};
    });
    buildInputs = l.map (mod: l.evalModules {
      modules = [mod];
      specialArgs = lib.recursiveUpdateUntil (path: l: r: (lib.traceVal path) == ["dependencySets" "nixpkgs"]) specialArgs {dependencySets.nixpkgs = specialArgs.dependencySets.nixpkgs.pkgsHostTarget;};
    });
  };
}
