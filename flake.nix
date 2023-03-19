{
  inputs = {
    cross-compile-test = {
      url = "github:BurNiinTRee/cross-compile-test";
      flake = false;
    };
    drv-parts.url = "github:davhau/drv-parts";
    hercules-ci-agent = {
      url = "github:hercules-ci/hercules-ci-agent";
      flake = false;
    };
  };
  outputs = inputs @ {
    self,
    nixpkgs,
    drv-parts,
    flake-parts,
    hercules-ci-agent,
    cross-compile-test,
  }:
    flake-parts.lib.mkFlake {inherit inputs;} ({lib, ...}: {
      systems = ["x86_64-linux"];
      debug = true;

      imports = [
        (hercules-ci-agent + /variants.nix)
        drv-parts.modules.flake-parts.drv-parts
      ];

      variants = let
        crossSystems = {
          aarch64-linux = lib.systems.examples.aarch64-multiplatform;
        };
      in
        lib.mapAttrs (_: crossSystem: {
          perSystem = {system, ...}: {
            _module.args.pkgs = import nixpkgs {inherit system crossSystem;};
          };
        })
        crossSystems;

      perSystem = {
        config,
        self',
        pkgs,
        ...
      }: {
        drvs = {
          mylib = {
            imports = [./mylib.nix];
            deps.mylib-src = cross-compile-test + /mylib;
          };
          generator = {
            imports = [./generator.nix];
            deps.generator-src = cross-compile-test + /generator;
          };
          hello = {
            imports = [./hello.nix];
            deps.hello-src = cross-compile-test + /hello;
          };
        };
        packages = let
          packages' = config.variants.aarch64-linux.packages;
        in {
          crossLib = packages'.mylib;
          crossHello = packages'.hello;
        };
      };
    });
}
