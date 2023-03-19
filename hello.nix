{
  drv-parts,
  lib,
  config,
  specialArgs,
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
    mylib = packages.mylib.extendModules {
      specialArgs = lib.recursiveUpdateUntil (path: l: r: lib.last path == "nixpkgs") specialArgs {dependencySets.nixpkgs = specialArgs.dependencySets.nixpkgs.pkgsHostTarget;};
    };
    generator = packages.generator.extendModules {
      specialArgs = lib.recursiveUpdateUntil (path: l: r: lib.last path == "nixpkgs") specialArgs {dependencySets.nixpkgs = specialArgs.dependencySets.nixpkgs.pkgsBuildHost;};
    };
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
      generator.config.public
    ];
    buildInputs = with config.deps; [
      mylib.config.public
    ];
  };
}
