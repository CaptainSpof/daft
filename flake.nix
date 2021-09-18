{
  description = "A devShell example";

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
        overlays = [ (import rust-overlay) devshell-flake.overlay ];
        pkgs = import nixpkgs { inherit system overlays; };
        rust-wasm = pkgs.rust-bin.nightly.latest.default.override {
          extensions = [ "rust-src" ];
          targets = [ "wasm32-unknown-unknown"];
        };
      in {

        # `nix develop`
        devShell = with pkgs; let
          esc = "";

          orange = "${esc}[38;5;202m";
          reset = "${esc}[0m";
          bold = "${esc}[1m";
        in
          devshell.mkShell {
            imports = [
              (devshell.importTOML ./nix/commands.toml)
              # (devshell.importTOML ./nix/env.toml)
            ];

            motd = ''
                  ${orange}$(${pkgs.figlet}/bin/figlet ${name})${reset}
                  $(type -p menu &>/dev/null && menu)
          '';

            packages = with pkgs; [
              openssl
              pkg-config
              pkgconfig
              rust-wasm
              trunk
              wasm-bindgen-cli
              zola
            ];

            env = [
              {
                name = "CARGO_BUILD_TARGET";
                value = "wasm32-unknown-unknown";
              }
            ];

            # commands = with pkgs; [
            # ];
          };

      });
}
