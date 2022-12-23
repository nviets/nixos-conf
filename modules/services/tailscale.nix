{ config, lib, pkgs, ... }: {
  networking.firewall.checkReversePath = "loose";
  services = with pkgs; {
    tailscale = {
      enable = true;
      permitCertUid = "nathanviets";
    };
  };
}
