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

    coreweave.url = "git+ssh://git@github.com/coreweave/coreweave.nix";
    coreweave.inputs.nixpkgs.follows = "nixpkgs";

    # disabled flakes on work local
    # nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    #
    # agenix.url = "github:ryantm/agenix";
    # agenix-rekey.url = "github:oddlama/agenix-rekey";
    # agenix-rekey.inputs.nixpkgs.follows = "nixpkgs";
    #
    # private-fonts.url = "git+ssh://git@github.com/mostlymaxi/private-fonts.git?shallow=1";
    # private-fonts.inputs.nixpkgs.follows = "nixpkgs";

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
      homeConfigurations = {
        # Ubuntu Work VDI (why no nixos :[ )
        vdi-1 =
          let
            inherit (inputs.nixpkgs) lib;
            mylib = import ./utils.nix { inherit lib; };

            username = "masaparov";
            hostname = "masaparov-1";

            system = "x86_64-linux";
            # standalone HM workaround
            osConfig.host.is_headless = true;

            pkgs = import nixpkgs {
              inherit system;
              config = {
                allowUnfree = true;
              };
            };

            extraSpecialArgs = inputs // {
              inherit
                hostname
                username
                mylib
                osConfig
                ;
            };
          in
          home-manager.lib.homeManagerConfiguration {
            inherit extraSpecialArgs pkgs;

            modules = [
              ./hosts/${hostname}/home.nix
            ];
          };
      };

      darwinConfigurations = {
        # Work Laptop
        tangerine =
          let
            inherit (inputs.nixpkgs) lib;
            mylib = import ./utils.nix { inherit lib; };

            username = "masaparov";
            hostname = "CW-D0XG2Q16P7-L";

            specialArgs = {
              inherit hostname username mylib;
            };
          in
          nix-darwin.lib.darwinSystem {
            inherit specialArgs;
            system = "aarch64-darwin";

            modules = [
              ./hosts/tangerine

              home-manager.darwinModules.home-manager
              {
                home-manager.useGlobalPkgs = true;
                home-manager.useUserPackages = true;

                home-manager.extraSpecialArgs = inputs // specialArgs;

                home-manager.users.${username} = import ./hosts/tangerine/home.nix;

              }
            ];
          };

        orange =
          let
            inherit (inputs.nixpkgs) lib;
            mylib = import ./utils.nix { inherit lib; };

            username = "maxi";
            hostname = "orange";

            specialArgs = {
              inherit hostname username mylib;
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

                home-manager.extraSpecialArgs = inputs // specialArgs;

                # home-manager.users.${username} = import ./hosts/${hostname}/${username}/home.nix;
                home-manager.users.${username} = import ./hosts/${hostname}/home.nix;

              }
            ];
          };
      };

      nixosConfigurations = {
        blueberry =
          let
            inherit (inputs.nixpkgs) lib;
            mylib = import ./utils.nix { inherit lib; };

            username = "maxi";
            hostname = "blueberry";

            specialArgs = { inherit hostname username mylib; };
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

                home-manager.extraSpecialArgs = inputs // specialArgs;

                # home-manager.users.${username} = import ./hosts/${hostname}/${username}/home.nix;
                home-manager.users.${username} = import ./hosts/${hostname}/home.nix;
              }
            ];
          };

      };
    };

}
