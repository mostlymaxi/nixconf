{
  description = "maxi's WIP NixOS configuration";

  nixConfig = {
    # substituers will be appended to the default substituters when fetching packages
    # nix com    extra-substituters = [munity's cache server
    # extra-substituters = [
    #   "https://nix-community.cachix.org"
    # ];
    # extra-trusted-public-keys = [
    #   "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
    # ];
  };

  inputs = {
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-24.11";
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    niri.url = "github:sodiboo/niri-flake";
    catppuccin.url = "github:catppuccin/nix";
  };

  outputs = inputs @ {
    self,
    nixpkgs,
    home-manager,
    ...
  }: {
    nixosConfigurations = {
      orange-vm = let
        username = "maxi";
        specialArgs = {inherit username;};
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

              home-manager.extraSpecialArgs = inputs // specialArgs;
              home-manager.users.${username} = import ./users/${username}/home.nix;
            }
          ];
        };
	strawberry = let
		username = "maxi";
		specialArgs = {inherit username;};
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
            	      # home-manager.sharedModules = [ niri.homeModules.niri ];

		      home-manager.extraSpecialArgs = inputs // specialArgs;
		      home-manager.users.${username} = import ./users/${username}/home.nix;
		    }
		  ];
		};
    };
  };
}
