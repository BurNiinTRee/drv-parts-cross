{drv-parts, config, ...}: {
  imports = [drv-parts.modules.drv-parts.mkDerivation];
  deps = {nixpkgs, ...}: {
    inherit (nixpkgs) stdenv;
    inherit (nixpkgs.buildPackages) meson ninja;
  };

  name = "mylib";
  src = builtins.path {path = ../mylib; name = "mylib-src";};
  nativeBuildInputs = with config.deps; [meson ninja];
}
