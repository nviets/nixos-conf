{ config, lib, pkgs, ... }: {
  services = with pkgs; {
    slurm = {
      nodeName = [
        "mini Sockets=1 RealMemory=12000 CoresPerSocket=2 ThreadsPerCore=2 State=UNKNOWN"
        "sparkler Sockets=2 RealMemory=29000 CoresPerSocket=16 ThreadsPerCore=1 State=UNKNOWN"
      ];
      partitionName = [
        "batch Nodes=mini,sparkler Default=YES MaxTime=INFINITE State=UP"
        "mini Nodes=mini Default=NO MaxTime=INFINITE State=UP"
        "sparkler Nodes=sparkler Default=NO MaxTime=INFINITE State=UP"
      ];
      extraConfig = ''
        SlurmctldHost=mini
        SlurmctldHost=sparkler
        SlurmctldLogFile=/var/log/slurm/slurmctld.log
        SlurmdLogFile=/var/log/slurm/slurmd.log
        ProctrackType=proctrack/cgroup
        #FastSchedule=1
        SchedulerType=sched/backfill
        SelectType=select/cons_tres
        ReturnToService=1
        TaskPlugin=task/cgroup
        InactiveLimit=0
        KillWait=30
        MinJobAge=300
        SlurmctldTimeout=120
        SlurmdTimeout=300
        Waittime=0
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
  };
}
