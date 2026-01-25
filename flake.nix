{
  description = "Example nix-darwin system flake";

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

    stylix.url = "github:danth/stylix";

    spicetify.url = "github:Gerg-L/spicetify-nix";
    spicetify.inputs.nixpkgs.follows = "nixpkgs";

    private-fonts.url = "git+ssh://git@github.com/mostlymaxi/private-fonts.git?shallow=1";
    private-fonts.inputs.nixpkgs.follows = "nixpkgs";

  };

  outputs =
    inputs@{
      self,
      nixpkgs,
      home-manager,
      nix-darwin,
      ...
    }:
    {
      darwinConfigurations = {
        orange =
          let
            inherit (inputs.nixpkgs) lib;
            mylib = import ./utils.nix { inherit lib; };

            username = "maxi";
            hostname = "orange";

            specialArgs = {
              inherit inputs hostname username mylib;
            };
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
      };

      nixosConfigurations = {
        strawberry =
          let
            hostname = "strawberry";
            username = "maxi";
            specialArgs = { inherit hostname username inputs; };
          in
          nixpkgs.lib.nixosSystem {
            inherit specialArgs;
            system = "x86_64-linux";

            modules = [
              ./hosts/strawberry

              home-manager.nixosModules.home-manager
              {
                home-manager.useGlobalPkgs = true;
                home-manager.useUserPackages = true;

                home-manager.extraSpecialArgs = specialArgs;
                home-manager.users.${username} = import ./users/${username}/home.nix;
              }
            ];
          };
        blueberry =
          let
            inherit (inputs.nixpkgs) lib;
            mylib = import ./utils.nix { inherit lib; };

            username = "maxi";
            hostname = "blueberry";

            specialArgs = { inherit inputs hostname username mylib; };
          in
          nixpkgs.lib.nixosSystem {
            inherit specialArgs;
            system = "aarch64-linux";

            modules = [
              ./hosts/${hostname}

              home-manager.nixosModules.home-manager
              {
                home-manager.useGlobalPkgs = true;
                home-manager.useUserPackages = true;

                home-manager.extraSpecialArgs = specialArgs;

                home-manager.users.${username} = import ./hosts/${hostname}/home.nix;
              }
            ];
          };

      };
    };

}
