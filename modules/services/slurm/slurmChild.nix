{ config, lib, pkgs, ... }: {
  imports = [(import ./nodeLayout.nix)];
  networking.firewall = {
    enable = true;
    allowedTCPPorts = [ 3306 6817 6818 6819 ];
  };
  services = with pkgs; {
    slurm = {
      server.enable = true;
      enableStools = true;
      client.enable = true;
      #controlMachine = "mini";
      clusterName = "home";
      dbdserver = {
        #enable = true;
        enable = false;
        dbdHost = "mini";
        storagePassFile = "/var/keys/slurm/slurmStoragePassword";
        extraConfig = ''
          LogFile=/var/log/slurm/slurmdbd.log
        '';
      };
    };
    munge = {
      enable = true;
      password = "/var/keys/munge/munge.key";
    };
  };
}
