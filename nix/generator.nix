{
  drv-parts,
  dependencySets,
  config,
  ...
}: {
  imports = [drv-parts.modules.drv-parts.mkDerivation];
  deps = {nixpkgs, ...}: {
    inherit (nixpkgs) stdenv;
    inherit (nixpkgs.buildPackages) meson ninja pkg-config;
    mylib = import ./mylib.nix;
  };

  name = "generator";
  src = builtins.path {
    path = ../generator;
    name = "generator-src";
  };
  nativeBuildInputs = with config.deps; [meson ninja pkg-config];
  buildInputs = with config.deps; [(drv-parts.lib.derivationFromModules dependencySets mylib)];
}
