{
  dream2nix,
  lib,
  config,
  ...
}: let
  d = config.deps;
in {
  imports = [dream2nix.modules.drv-parts.mkDerivation];
  deps = {nixpkgs, ...}: {
    inherit (nixpkgs) stdenv;
    inherit (nixpkgs.pkgsBuildHost) meson ninja;
    src = lib.mkDefault null;
  };

  name = "mylib";
  version = "0.1.0";
  mkDerivation = {
    inherit (d) src;
    nativeBuildInputs = [d.meson d.ninja];
  };
}
