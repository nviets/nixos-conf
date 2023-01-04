{ config, lib, pkgs, ... }: {
  networking.firewall = {
    enable = true;
    allowedTCPPorts = [ 3306 6817 6818 6819 ];
  };
  services = with pkgs; {
    slurm = {
      server.enable = false;
      enableStools = true;
      client.enable = true;
      controlMachine = "mini";
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
        "mini Sockets=1 RealMemory=12000 CoresPerSocket=2 ThreadsPerCore=2"
        "sparkler Sockets=2 RealMemory=29000 CoresPerSocket=16 ThreadsPerCore=1"
      ];
      partitionName = [
        "batch Nodes=mini,sparkler Default=YES MaxTime=INFINITE State=UP"
        "mini Nodes=mini Default=NO MaxTime=INFINITE State=UP"
        "sparkler Nodes=sparkler Default=NO MaxTime=INFINITE State=UP"
      ];
      extraConfig = ''
        SlurmctldLogFile=/var/log/slurm/slurmctld.log
        SlurmdLogFile=/var/log/slurm/slurmd.log
        #ProctrackType=proctrack/cgroup
        FastSchedule=1
        SchedulerType=sched/backfill
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
