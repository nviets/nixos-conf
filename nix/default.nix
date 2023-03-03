#
# These are the diffent profiles that can be used when building Nix.
#
# flake.nix
#   └─ ./nix
#       └─ default.nix *
#

{ lib, inputs, nixpkgs, home-manager, nixgl, user, ... }:
let
  system = "aarch64-linux";
  pkgs = nixpkgs.legacyPackages.${system};
in
{
  pacman = home-manager.lib.homeManagerConfiguration {    # Currently only host that can be built
    inherit pkgs;
    extraSpecialArgs = { inherit inputs nixgl user; };
    modules = [
      #./pacman.nix
      ../hosts/home.nix
#      {
#        home = {
#          username = "${user}";
#          homeDirectory = "/home/${user}";
#          packages = [ pkgs.home-manager ];
#          #stateVersion = "22.05";
#        };
#      }
    ];
  };
}
