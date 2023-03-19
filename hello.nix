{
  drv-parts,
  lib,
  config,
  ...
}: {
  imports = [drv-parts.modules.drv-parts.mkDerivation];
  deps = {
    nixpkgs,
    packages,
    ...
  }: {
    inherit (nixpkgs) stdenv;
    inherit (nixpkgs.pkgsBuildHost) meson ninja pkg-config;
    mylib = packages.mylib;
    generator = packages.generator;
    hello-src = lib.mkDefault null;
  };

  name = "hello";
  version = "0.1.0";
  mkDerivation = {
    src = config.deps.hello-src;
    nativeBuildInputs = with config.deps; [
      meson
      ninja
      pkg-config
      generator
    ];
    buildInputs = with config.deps; [
      mylib
    ];
  };
}
