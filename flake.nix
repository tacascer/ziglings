{
  description = "Zig Nightly Environment";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";

    # The Zig overlay containing nightly and tagged releases
    zig-overlay.url = "github:mitchellh/zig-overlay";
  };

  outputs =
    {
      nixpkgs,
      flake-utils,
      zig-overlay,
      ...
    }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = import nixpkgs {
          inherit system;
          overlays = [ zig-overlay.overlays.default ];
        };
      in
      {
        devShells.default = pkgs.mkShell {
          buildInputs = [
            # Pulls the latest master branch build
            pkgs.zigpkgs.master
          ];
        };
      }
    );
}
