{
  dream2nix,
  lib,
  config,
  ...
}: let
  d = config.deps;
in {
  imports = [./mod-deps.nix];
  deps = {
    nixpkgs,
    ...
  }: {
    inherit (nixpkgs) stdenv;
    inherit (nixpkgs.pkgsBuildHost) meson ninja pkg-config;
    mylib = lib.mkDefault null;
    src = lib.mkDefault null;
  };

  name = "generator";
  version = "0.1.0";
  mkDerivation = {
    inherit (d) src;
    nativeBuildInputs = [d.meson d.ninja d.pkg-config];
  };
  buildInputs' = [d.mylib];
}
