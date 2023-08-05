{
  drv-parts,
  lib,
  config,
  ...
}: let
  d = config.deps;
in {
  imports = [./mod-deps.nix];
  deps = {
    nixpkgs,
    packages,
    ...
  }: {
    inherit (nixpkgs) stdenv;
    inherit (nixpkgs.pkgsBuildHost) meson ninja pkg-config;
    mylib = packages.mylib;
    generator-src = lib.mkDefault null;
  };

  name = "generator";
  version = "0.1.0";
  mkDerivation = {
    src = config.deps.generator-src;
    nativeBuildInputs = [d.meson d.ninja d.pkg-config];
  };
  buildInputs' = [d.mylib];
}
