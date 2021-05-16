{
  inputs = {
    utils.url = "github:numtide/flake-utils";
    naersk.url = "github:nmattia/naersk";
  };

  outputs = { self, nixpkgs, utils, naersk }:
    utils.lib.eachDefaultSystem (system: let
      pkgs = nixpkgs.legacyPackages."${system}";
      naersk-lib = naersk.lib."${system}";
      pkgBuildInputs = with pkgs; [
        zola
        rustc
        cargo
        openssl
        pkg-config
      ];
    in rec {
      # `nix build`
      packages.daft = naersk-lib.buildPackage {
        pname = "daft";
        root = ./.;
        nativeBuildInputs = pkgBuildInputs;
      };
      defaultPackage = packages.daft;

      # `nix run`
      apps.daft = utils.lib.mkApp {
        drv = packages.daft;
      };
      defaultApp = apps.daft;

      # `nix develop`
      devShell = pkgs.mkShell {
        nativeBuildInputs = pkgBuildInputs ++ (with pkgs; [
          rust-analyzer
          cargo-outdated
        ]);
      };
    });
}
