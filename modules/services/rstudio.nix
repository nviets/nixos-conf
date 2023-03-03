{ config, lib, pkgs, ... }: {
#  nixpkgs.overlays = [
#    (_: super:
#      with super; {
#        blas = blas.override {blasProvider = mkl;};
#        lapack = lapack.override {lapackProvider = mkl;};
#      })
#  ];
  networking.firewall = {
    enable = true;
    allowedTCPPorts = [ 8787 ];
  };
  services.rstudio-server = with pkgs; {
    enable = true;
    listenAddr = "192.168.0.236";
    package = rstudioServerWrapper.override {
      packages = [ (import ../../darwin/rEnv/r-packages.nix pkgs) ];
    };
  };
}
