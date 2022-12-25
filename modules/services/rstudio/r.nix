{ config, lib, pkgs, ... }: 
let
  R-with-my-packages = pkgs.rWrapper.override{ packages = [ (import ../../../darwin/r-packages.nix pkgs) ]; };
in
{
  environment.systemPackages = [ R-with-my-packages ];
}
