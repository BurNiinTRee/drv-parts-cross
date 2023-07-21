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
    generator = packages.generator;
    hello-src = lib.mkDefault null;
  };

  name = "hello";
  version = "0.1.0";
  nativeBuildInputs' = [
    d.generator
  ];
  buildInputs' = [
    d.mylib
  ];
  mkDerivation = {
    src = d.hello-src;
    nativeBuildInputs = [
      d.meson
      d.ninja
      d.pkg-config
    ];
  };
}
