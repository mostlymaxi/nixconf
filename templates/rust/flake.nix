{
  description = "Rust dev shell";

  # fenix publishes prebuilt toolchains to nix-community.cachix.org;
  # trusted nix users pick this up automatically, others run with
  # --accept-flake-config
  nixConfig = {
    extra-substituters = [ "https://nix-community.cachix.org" ];
    extra-trusted-public-keys = [
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
    ];
  };

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    fenix = {
      url = "github:nix-community/fenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    { nixpkgs, fenix, ... }:
    let
      forAllSystems = nixpkgs.lib.genAttrs [
        "x86_64-linux"
        "aarch64-linux"
        "aarch64-darwin"
      ];

      # toolchain defined once in ./rust-toolchain.toml so cargo/rustup and
      # nix agree on the exact same rust; re-pin sha256 (nix prints the new
      # hash) whenever rust-toolchain.toml or the fenix input changes
      mkToolchain =
        system:
        fenix.packages.${system}.fromToolchainFile {
          file = ./rust-toolchain.toml;
          sha256 = "sha256-A1abGIbOtcBSdrUMhDGrER3pRM1hQP4fp9gh3Y4PKc8=";
        };
    in
    {
      formatter = forAllSystems (system: nixpkgs.legacyPackages.${system}.nixfmt);

      # nix build / nix run — pname and version come from Cargo.toml
      packages = forAllSystems (
        system:
        let
          pkgs = nixpkgs.legacyPackages.${system};
          toolchain = mkToolchain system;
          rustPlatform = pkgs.makeRustPlatform {
            cargo = toolchain;
            rustc = toolchain;
          };
          cargoToml = builtins.fromTOML (builtins.readFile ./Cargo.toml);
        in
        {
          default = rustPlatform.buildRustPackage {
            pname = cargoToml.package.name;
            inherit (cargoToml.package) version;
            src = ./.;
            cargoLock.lockFile = ./Cargo.lock;
          };
        }
      );

      devShells = forAllSystems (
        system:
        let
          toolchain = mkToolchain system;
        in
        {
          default = nixpkgs.legacyPackages.${system}.mkShell {
            packages = [ toolchain ];
            # lets rust-analyzer find the standard library sources
            env.RUST_SRC_PATH = "${toolchain}/lib/rustlib/src/rust/library";
          };
        }
      );
    };
}
