{
  inputs = {
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
  }:
    flake-parts.lib.mkFlake {inherit inputs;} ({lib, ...}: {
      systems = ["x86_64-linux"];

      imports = [(hercules-ci-agent + /variants.nix) drv-parts.modules.flake-parts.drv-parts];

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

      perSystem = {config, ...}: {
        drvs = {
          mylib = {
            imports = [./nix/mylib.nix];
          };
          generator = {
            imports = [./nix/generator.nix];
          };
          hello = {
            imports = [./nix/hello.nix];
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
