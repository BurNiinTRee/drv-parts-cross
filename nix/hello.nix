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
    generator = import ./generator.nix;
  };

  name = "hello";
  src = builtins.path {
    path = ../hello;
    name = "hello-src";
  };
  nativeBuildInputs = with config.deps; [
    meson
    ninja
    pkg-config
    (drv-parts.lib.derivationFromModules (dependencySets // {nixpkgs = dependencySets.nixpkgs.buildPackages;}) generator)
  ];
  buildInputs = with config.deps; [
    (drv-parts.lib.derivationFromModules dependencySets mylib)
  ];
}
