{
  description = "NixOS configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    nix-software-center.url = "github:vlinkz/nix-software-center";
#    sops-nix.url = "github:Mic92/sops-nix";
    agenix.url = "github:ryantm/agenix";
  };

  outputs = inputs@{ nixpkgs, home-manager, agenix, ... }: {
    nixosConfigurations = {
      # TODO please change the hostname to your own
      nixos = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./configuration.nix
#          sops-nix.nixosModules.sops
#          ./services/gpg-agent.nix
          agenix.nixosModules.default
          # make home-manager as a module of nixos
          # so that home-manager configuration will be deployed automatically when executing `nixos-rebuild switch`
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;

            # TODO replace ryan with your own username
            home-manager.users.alternex = { pkgs, ... }: { 
             imports = [ ./home.nix ./dconf.nix ];
            };
            # Optionally, use home-manager.extraSpecialArgs to pass arguments to home.nix
          }
        ];
      };
    };
  };
}
