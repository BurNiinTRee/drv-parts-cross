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
  }:
    {
      inherit (nixpkgs) stdenv;
      inherit (nixpkgs.pkgsBuildHost) meson ninja pkg-config;
      mylib = packages.mylib;
      generator-src = lib.mkDefault null;
    };

  name = "generator";
  version = "0.1.0";
  mkDerivation = {
    src = config.deps.generator-src;
    nativeBuildInputs = with config.deps; [meson ninja pkg-config];
    buildInputs = with config.deps; [mylib];
  };
}
