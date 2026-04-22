{
  description = "NixOS and nix-darwin system configurations";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    nix-darwin.url = "github:nix-darwin/nix-darwin/master";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";

    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    nixvim.url = "github:nix-community/nixvim";
    nixvim.inputs.nixpkgs.follows = "nixpkgs";

    nixos-hardware.url = "github:NixOS/nixos-hardware/master";

    agenix.url = "github:ryantm/agenix";
    agenix-rekey.url = "github:oddlama/agenix-rekey";
    agenix-rekey.inputs.nixpkgs.follows = "nixpkgs";

    niri.url = "github:sodiboo/niri-flake";
    niri.inputs.nixpkgs.follows = "nixpkgs";

    mango.url = "github:DreamMaoMao/mango";
    mango.inputs.nixpkgs.follows = "nixpkgs";

    stylix.url = "github:danth/stylix";
    stylix.inputs.nixpkgs.follows = "nixpkgs";

    spicetify.url = "github:Gerg-L/spicetify-nix";
    spicetify.inputs.nixpkgs.follows = "nixpkgs";

    ghostty-nightly.url = "github:ghostty-org/ghostty";

    disko.url = "github:nix-community/disko";
    disko.inputs.nixpkgs.follows = "nixpkgs";

    private-fonts.url = "git+ssh://git@github.com/mostlymaxi/private-fonts.git?shallow=1";
    private-fonts.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs =
    inputs@{
      nixpkgs,
      home-manager,
      nix-darwin,
      ...
    }:
    let
      inherit (inputs.nixpkgs) lib;
      mylib = import ./utils.nix { inherit lib; };

      mkSpecialArgs = hostname: username: {
        inherit
          inputs
          hostname
          username
          mylib
          ;
      };

      mkNixos =
        {
          hostname,
          system,
          username ? "maxi",
          hostPath ? ./hosts/${hostname},
        }:
        let
          specialArgs = mkSpecialArgs hostname username;
        in
        nixpkgs.lib.nixosSystem {
          inherit specialArgs system;

          modules = [
            inputs.disko.nixosModules.disko
            inputs.agenix.nixosModules.default
            ./modules
            hostPath

            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.extraSpecialArgs = specialArgs;
              home-manager.users.${username} = import ./hosts/${hostname}/home.nix;
            }
          ];
        };

      mkDarwin =
        {
          hostname,
          username ? "maxi",
        }:
        let
          specialArgs = mkSpecialArgs hostname username;
        in
        nix-darwin.lib.darwinSystem {
          inherit specialArgs;
          system = "aarch64-darwin";

          modules = [
            ./hosts/${hostname}

            home-manager.darwinModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.extraSpecialArgs = specialArgs;
              home-manager.users.${username} = import ./hosts/${hostname}/home.nix;
            }
          ];
        };
    in
    {
      formatter.x86_64-linux = nixpkgs.legacyPackages.x86_64-linux.nixfmt;
      formatter.aarch64-linux = nixpkgs.legacyPackages.aarch64-linux.nixfmt;
      formatter.aarch64-darwin = nixpkgs.legacyPackages.aarch64-darwin.nixfmt;

      darwinConfigurations = {
        orange = mkDarwin { hostname = "orange"; };
      };

      nixosConfigurations = {
        pickle = mkNixos {
          hostname = "pickle";
          system = "x86_64-linux";
        };
        strawberry = mkNixos {
          hostname = "strawberry";
          system = "x86_64-linux";
          hostPath = ./hosts/pickle;
        };
        blueberry-1 = mkNixos {
          hostname = "blueberry-1";
          system = "aarch64-linux";
        };
      };

      packages.x86_64-linux.installer =
        (nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [
            "${nixpkgs}/nixos/modules/installer/cd-dvd/installation-cd-minimal.nix"
            ./modules/system/installer.nix
          ];
        }).config.system.build.isoImage;

      packages.aarch64-linux.installer =
        (nixpkgs.lib.nixosSystem {
          system = "aarch64-linux";
          modules = [
            "${nixpkgs}/nixos/modules/installer/sd-card/sd-image-aarch64.nix"
            ./modules/system/installer.nix
            {
              # enable USB boot on Pi 3 (burns one-time fuse, ignored on Pi 4/5)
              sdImage.firmwareConfig = "program_usb_boot_mode=1";
            }
          ];
        }).config.system.build.sdImage;
    };

}
