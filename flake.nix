{
  description = "A devShell example";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    rust-overlay.url = "github:oxalica/rust-overlay";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, rust-overlay, flake-utils, ... }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pname = "daft";
        overlays = [ (import rust-overlay) ];
        pkgs = import nixpkgs { inherit system overlays; };
        rust-wasm = pkgs.rust-bin.nightly.latest.default.override {
          extensions = [ "rust-src" ];
          targets = [ "wasm32-unknown-unknown"];
        };
      in {
        devShell = pkgs.mkShell {

          CARGO_BUILD_TARGET =  "wasm32-unknown-unknown";

          buildInputs = with pkgs; [
            openssl
            pkg-config
            pkgconfig
            rust-wasm
            trunk
            wasm-bindgen-cli
            zola
            # pkgs.rust-bin.nightly.latest.default
          ];

          shellHook = ''
            echo "Welcome to ${pname} !"
            # [ ! -f ./target/$CARGO_BUILD_TARGET/debug/${pname} ] && cargo build ; ln -sf ./target/$CARGO_BUILD_TARGET/debug/${pname} ${pname}
          '';
        };
      });
}
