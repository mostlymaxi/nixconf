{
  description = "maxi's WIP NixOS configuration";

  inputs = {
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-25.11";
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixvim = {
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    niri = {
      url = "github:sodiboo/niri-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    wlavu = {
      url = "github:philschonholzer/wlavu";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    stylix.url = "github:danth/stylix";

    spicetify-nix = {
      url = "github:Gerg-L/spicetify-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    inputs@{
      self,
      nixpkgs,
      home-manager,
      ...
    }:
    {
      nixosConfigurations = {
        orange-vm =
          let
            username = "maxi";
            specialArgs = { inherit username inputs; };
          in
          nixpkgs.lib.nixosSystem {
            inherit specialArgs;
            system = "x86_64-linux";

            modules = [
              ./hosts/orange-vm

              home-manager.nixosModules.home-manager
              {
                home-manager.useGlobalPkgs = true;
                home-manager.useUserPackages = true;

                home-manager.extraSpecialArgs = { inherit specialArgs; };
                home-manager.users.${username} = import ./users/${username}/home.nix;
              }
            ];
          };
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
      };
    };
}
