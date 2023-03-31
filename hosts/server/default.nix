#
#  Specific system configuration settings for server 
#
#  flake.nix
#   ├─ ./hosts
#   │   └─ ./server
#   │        ├─ default.nix *
#   │        └─ hardware-configuration.nix
#   └─ ./modules
##       ├─ ./desktop
##       │   ├─ ./bspwm
##       │   │   └─ bspwm.nix
##       │   └─ ./virtualisation
##       │       └─ default.nix
##       ├─ ./programs
##       │   └─ games.nix
#       ├─ ./services
#       │   └─ default.nix
#       └─ ./hardware
#           └─ default.nix
#

{ pkgs, pkgsLatest, lib, user, ... }:

{
  imports =                                               # For now, if applying to other system, swap files
    [(import ./hardware-configuration.nix)] ++            # Current system hardware config @ /etc/nixos/hardware-configuration.nix
    #[(import ../../modules/programs/games.nix)] ++        # Gaming
    #[(import ../../modules/desktop/bspwm/default.nix)] ++   # Window Manager
    #[(import ../../modules/desktop/hyprland/default.nix)] ++ # Window Manager
    #[(import ../../modules/desktop/gnome/default.nix)] ++ # Desktop Environment
    #[(import ../../modules/editors/emacs/native.nix)] ++  # Native doom emacs instead of nix-community flake
    #(import ../../modules/desktop/virtualisation) ++      # Virtual Machines & VNC
    [(import ../../modules/services/rstudio.nix)] ++       # RStudio Server
    [(import ../../darwin/rEnv/r.nix)] ++                  # R matched to RStudio
    [(import ../../modules/services/slurm/slurmMaster.nix)] ++ # Slurm
    [(import ../../modules/services/tailscale.nix)] ++     # Tailscale
    [(import ../../modules/services/hass.nix)] ++          # Home Assistant
    [(import ../../modules/services/telegraf.nix)] ++      # telegraf
    [(import ../../modules/services/gitlab.nix)] ++        # gitlab
    [(import ../../modules/services/hydra.nix)] ++         # hydra setup
    [(import ../../modules/services/jira.nix)] ++          # jira setup with gitlab integration
    (import ../../modules/hardware);                       # Hardware devices
  boot = {                                      # Boot options
    kernelPackages = pkgs.linuxPackages_latest;
    supportedFilesystems = [ "btrfs" ];
    initrd.kernelModules = [ "zstd" "btrfs" ];
    
    loader = {                                  # For legacy boot:
      efi.canTouchEfiVariables = true;
      efi.efiSysMountPoint = "/boot";
      grub = {
        enable = true;
        version = 2;
        devices = [ "nodev" ];
        efiSupport = true;
        useOSProber = true;
        configurationLimit = 2;
      };
      timeout = 1;                              # Grub auto select time
    };
    tmpOnTmpfs = true;
    cleanTmpDir = true;
    devShmSize = "50%";
  };

  hardware = {
    enableAllFirmware = true;
    sane = {                                    # Used for scanning with Xsane
      enable = true;
      extraBackends = [ pkgs.sane-airscan ];
    };
  };

  networking.hostName = "mini";

  fileSystems = {
    "/".options = [ "compress=zstd" "autodefrag" "noatime" ];
    "/home".options = [ "compress=zstd" "autodefrag" "noatime" ];
    "/nix".options = [ "compress=zstd" "autodefrag" "noatime" ];
  };

  programs.dconf.enable = true;
  programs.mosh.enable = true;

  environment = {                               # Packages installed system wide
    systemPackages = with pkgs; [               # This is because some options need to be configured.
#      discord
      #plex
      simple-scan
      x11vnc
      wacomtablet
    ];
  };

  services = {
    btrfs.autoScrub = {
      enable = true;
      fileSystems = [ "/" ];
    };
    blueman.enable = true;                      # Bluetooth
    printing = {                                # Printing and drivers for TS5300
      enable = true;
      drivers = [ pkgs.cnijfilter2 ];           # There is the possibility cups will complain about missing cmdtocanonij3. I guess this is just an error that can be ignored for now.
    };
    avahi = {                                   # Needed to find wireless printer
      enable = true;
      nssmdns = true;
      publish = {                               # Needed for detecting the scanner
        enable = true;
        addresses = true;
        userServices = true;
      };
    };
#    samba = {                                   # File Sharing over local network
#      enable = true;                            # Don't forget to set a password:  $ smbpasswd -a <user>
#      shares = {
#        share = {
#          "path" = "/home/${user}";
#          "guest ok" = "yes";
#          "read only" = "no";
#        };
#      };
#      openFirewall = true;
#    };
  };

  nixpkgs.overlays = [                          # This overlay will pull the latest version of Discord
    (self: super: {
      discord = super.discord.overrideAttrs (
        _: { src = builtins.fetchTarball {
          url = "https://discord.com/api/download?platform=linux&format=tar.gz"; 
          sha256 = "1pw9q4290yn62xisbkc7a7ckb1sa5acp91plp2mfpg7gp7v60zvz";
        };}
      );
    })
#    (_: super:
#      with super; {
#        blas = blas.override {blasProvider = mkl;};
#        lapack = lapack.override {lapackProvider = mkl;};
#    })
  ];
}
