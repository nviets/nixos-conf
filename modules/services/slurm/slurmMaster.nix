{ config, lib, pkgs, ... }: {
  imports = [(import ./nodeLayout.nix)];
  networking.firewall = {
    enable = true;
    allowedTCPPorts = [ 3306 6817 6818 6819 ];
  };
  services = with pkgs; {
    mysql = {
      enable = true;
      package = pkgs.mariadb;
      ensureDatabases = [ "slurm_acct_db" ];
      ensureUsers = [ {
        name = "slurm";
        ensurePermissions = { "slurm_acct_db.*" = "ALL PRIVILEGES"; };
      } ];
      settings = {
        mysqld = {
          innodb_buffer_pool_size = "6G";
          innodb_lock_wait_timeout = "500";
          innodb_log_file_size = "64M";
        };
      };
    };
    slurm = {
      server.enable = true;
      enableStools = true;
      client.enable = true;
      #controlMachine = "mini";
      clusterName = "home";
      dbdserver = {
        #enable = true;
        enable = true;
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
