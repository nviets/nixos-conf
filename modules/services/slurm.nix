{ config, lib, pkgs, ... }: {
  services = with pkgs; {
      slurm = {
      server.enable = false;
      enableStools = true;
      client.enable = true;
      controlMachine = "asus";
      controlAddr = "192.168.0.159";
      clusterName = "default";
      dbdserver = {
        enable = true;
        dbdHost = "asus";
        storagePassFile = "/var/keys/slurm/slurmStoragePassword";
      };
      nodeName = [
        "asus Sockets=1 RealMemory=8000 CoresPerSocket=4 ThreadsPerCore=2 Feature=HyperThread"
        "sparkler Sockets=2 RealMemory=29000 CoresPerSocket=15 ThreadsPerCore=1"
        "mini Sockets=1 RealMemory=12000 CoresPerSocket=2 ThreadsPerCore=1"
      ];
      partitionName = [
        "debug Nodes=asus Default=YES MaxTime=INFINITE State=UP"
        "batch Nodes=sparkler MaxTime=INFINITE State=UP"
        "batch Nodes=mini MaxTime=INFINITE State=UP"
      ];
      extraConfig = ''
        # Scheduling Policies
        SchedulerType=sched/builtin
        PreemptType=preempt/partition_prio
        PreemptMode=GANG,SUSPEND
        # AllocatonPolicies
        SelectType=select/cons_res
        SelectTypeParameters=CR_Core
        TaskPlugin=task/cgroup
        AccountingStorageHost=asus
        AccountingStorageType=accounting_storage/slurmdbd
      '';
    };
    munge = {
      enable = true;
      password = "/etc/munge/munge.key";
    };
  };
}
