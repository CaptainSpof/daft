{
  description = "Daft: Zola blog and CV";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    rust-overlay.url = "github:oxalica/rust-overlay";
    flake-utils.url = "github:numtide/flake-utils";
    devshell-flake.url = "github:numtide/devshell";
  };

  outputs = { self, nixpkgs, rust-overlay, devshell-flake, flake-utils, ... }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        name = "daft";
        overlays = [ (import rust-overlay) devshell-flake.overlays.default ];
        pkgs = import nixpkgs { inherit system overlays; };
        rust-wasm = pkgs.rust-bin.nightly.latest.default.override {
          extensions = [ "rust-src" ];
          targets = [ "wasm32-unknown-unknown"];
        };

        esc = "";
        orange = "${esc}[38;5;202m";
        reset = "${esc}[0m";
      in {

        # `nix develop` (or direnv): everything needed to build the site and the CV
        devShells.default = pkgs.devshell.mkShell {
          imports = [ (pkgs.devshell.importTOML ./nix/commands.toml) ];

          motd = ''
                ${orange}$(${pkgs.figlet}/bin/figlet ${name})${reset}
                $(type -p menu &>/dev/null && menu)
          '';

          packages = with pkgs; [
            zola
            typst
          ];

          env = [
            {
              # Fonts used by cv/cv.typ, picked up by typst
              name = "TYPST_FONT_PATHS";
              value = "${pkgs.roboto-slab}/share/fonts:${pkgs.open-sans}/share/fonts";
            }
          ];
        };

        # `nix develop .#wasm`: toolchain for the Yew experiment in src/
        devShells.wasm = pkgs.devshell.mkShell {
          name = "${name}-wasm";

          packages = with pkgs; [
            openssl
            pkg-config
            rust-wasm
            trunk
            wasm-bindgen-cli
          ];

          env = [
            {
              name = "CARGO_BUILD_TARGET";
              value = "wasm32-unknown-unknown";
            }
          ];
        };
      });
}
