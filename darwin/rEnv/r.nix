{ config, lib, pkgs, ... }: 
let
  R-with-my-packages = pkgs.rWrapper.override{ packages = [ (import ./r-packages.nix pkgs) ]; };
in
{
  environment.systemPackages = [ R-with-my-packages ];
}
