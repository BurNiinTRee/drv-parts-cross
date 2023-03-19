{
  drv-parts,
  lib,
  config,
  ...
}: {
  imports = [drv-parts.modules.drv-parts.mkDerivation];
  deps = {nixpkgs, ...}: {
    inherit (nixpkgs) stdenv;
    inherit (nixpkgs.pkgsBuildHost) meson ninja;
    mylib-src = lib.mkDefault null;
  };

  name = "mylib";
  version = "0.1.0";
  mkDerivation = {
    src = config.deps.mylib-src;
    nativeBuildInputs = with config.deps; [meson ninja];
  };
}
