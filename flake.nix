{

description = "Clean configuration flake";

inputs = {
    #Source for NixOs
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.05";
    home-manager.url = "github:nix-community/home-manager/release-25.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
   };

outputs = { nixpkgs, self, home-manager,  ... }:
let
    system = "x86_64-linux";
    pkgs = nixpkgs.legacyPackages.${system};
    lib = nixpkgs.lib;
in {
    #----------------NIXOS-----------------------------
    nixosConfigurations = {
    "nixos" = lib.nixosSystem {
    inherit system;
    modules = [
        ./configuration.nix
        ./hardware-configuration.nix
        ./networking.nix
        ./printer.nix
        ./plasma.nix
        #-----HOME MANAGER MODULES----------------
        home-manager.nixosModules.home-manager
         {
           home-manager.useGlobalPkgs = true;
           home-manager.useUserPackages = true;
           home-manager.users.nixos_u0 = import ./home/users/nixos_u0.nix;
           # This enables automatic backup of conflicting files
           home-manager.backupFileExtension = "backup";
         }
       ];
    };


    };
};
}
