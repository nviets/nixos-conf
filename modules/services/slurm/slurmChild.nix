{ config, lib, pkgs, ... }: {
  networking.firewall = {
    enable = true;
    allowedTCPPorts = [ 3306 6817 6818 6819 ];
  };
  services = with pkgs; {
    slurm = {
      #server.enable = true;
      server.enable = false;
      enableStools = true;
      client.enable = true;
      controlMachine = "mini";
      #controlAddr = "192.168.0.236";
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
      nodeName = [
        "mini Sockets=1 RealMemory=12000 CoresPerSocket=2 ThreadsPerCore=1"
        "sparkler Sockets=2 RealMemory=29000 CoresPerSocket=15 ThreadsPerCore=1"
      ];
      partitionName = [
        "mini Nodes=mini MaxTime=INFINITE State=UP"
        "sparkler Nodes=sparkler MaxTime=INFINITE State=UP"
        "batch Nodes=mini,sparkler MaxTime=INFINITE State=UP"
      ];
      extraConfig = ''
        SlurmctldLogFile=/var/log/slurm/slurmctld.log
        SlurmdLogFile=/var/log/slurm/slurmd.log
        ProctrackType=proctrack/cgroup
      '';
      extraCgroupConfig = ''
        CgroupAutomount=yes
        CgroupMountpoint=/sys/fs/cgroup
        ConstrainCores=yes
        ConstrainDevices=yes
        ConstrainKmemSpace=no        #avoid known Kernel issues
        ConstrainRAMSpace=yes
        ConstrainSwapSpace=yes
      '';
    };
    munge = {
      enable = true;
      password = "/var/keys/munge/munge.key";
    };
  };
}
