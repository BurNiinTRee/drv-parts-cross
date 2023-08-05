{
  inputs = {
    cross-compile-test = {
      url = "github:BurNiinTRee/cross-compile-test";
      flake = false;
    };
    dream2nix.url = "github:nix-community/dream2nix";
    hercules-ci-agent = {
      url = "github:hercules-ci/hercules-ci-agent";
      flake = false;
    };
  };
  outputs = inputs @ {
    self,
    nixpkgs,
    dream2nix,
    flake-parts,
    hercules-ci-agent,
    cross-compile-test,
  }:
    flake-parts.lib.mkFlake {inherit inputs;} ({
      config,
      lib,
      ...
    }: let
      drv-parts-modules = {
        mylib = {
          imports = [./mylib.nix];
          deps = {
            src = cross-compile-test + /mylib;
          };
        };
        generator = {
          imports = [./generator.nix];
          deps = {
            src = cross-compile-test + /generator;
            mylib = drv-parts-modules.mylib;
          };
        };
        hello = {
          imports = [./hello.nix];
          deps = {
            src = cross-compile-test + /hello;
            mylib = drv-parts-modules.mylib;
            generator = drv-parts-modules.generator;
          };
        };
      };
    in {
      systems = ["x86_64-linux"];
      debug = true;

      flake = {
        modules.drv-parts = drv-parts-modules;
      };

      imports = [
        (hercules-ci-agent + /nix/variants.nix)
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
      }: let
        _callModule = module:
          lib.evalModules {
            modules = [module dream2nix.modules.drv-parts.core];
            specialArgs.dream2nix = dream2nix;
            specialArgs.packageSets.nixpkgs = pkgs;
          };
        callModule = module: (_callModule module).config.public;
      in {
        packages =
          {
            mylib = callModule drv-parts-modules.mylib;
            generator = callModule drv-parts-modules.generator;
            hello = callModule drv-parts-modules.hello;
          }
          // (let
            packages' = config.variants.aarch64-linux.packages;
          in {
            crossLib = packages'.mylib;
            crossGen = packages'.generator;
            crossHello = packages'.hello;
          });
      };
    });
}
