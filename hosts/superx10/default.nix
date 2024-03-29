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

{ config, pkgs, pkgsLatest, lib, user, ... }:

{
  imports =                                               # For now, if applying to other system, swap files
    [(import ./hardware-configuration.nix)] ++            # Current system hardware config @ /etc/nixos/hardware-configuration.nix
    [(import ../../modules/programs/games.nix)] ++        # Gaming
    [(import ../../modules/desktop/bspwm/default.nix)] ++   # Window Manager
    #[(import ../../modules/desktop/hyprland/default.nix)] ++ # Window Manager
    #[(import ../../modules/desktop/gnome/default.nix)] ++ # Desktop Environment
    #[(import ../../modules/editors/emacs/native.nix)] ++  # Native doom emacs instead of nix-community flake
    (import ../../modules/desktop/virtualisation) ++      # Virtual Machines & VNC
    #[(import ../../modules/services/rstudio.nix)] ++       # RStudio Server
    [(import ../../darwin/rEnv/r.nix)] ++                  # R matched to RStudio
    #[(import ../../modules/services/slurm/slurmChild.nix)] ++ # Slurm
    [(import ../../modules/services/tailscale.nix)] ++     # Tailscale
    #[(import ../../modules/services/hass.nix)] ++          # Home Assistant
    #[(import ../../modules/services/gitlab.nix)] ++        # gitlab
    (import ../../modules/hardware);                       # Hardware devices

  boot = {                                      # Boot options
    kernelPackages = pkgs.linuxPackages_latest;
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
    tmp = {
      useTmpfs = true;
      cleanOnBoot = true;
    };
    blacklistedKernelModules = [ "nouveau" ];
    binfmt.emulatedSystems = [ "aarch64-linux" "armv7l-linux" ];
  };

  hardware = {
    enableAllFirmware = true;
    sane = {                                    # Used for scanning with Xsane
      enable = true;
      extraBackends = [ pkgs.sane-airscan ];
    };
  };

  networking = {
    hostName = "superx10";
    hostId = "ca2486b7";
    firewall = {
      allowedTCPPorts = [ 7860 ];
    };
  };

  fileSystems = {
    "/".options = [ "compress=zstd" ];
    "/home".options = [ "compress=zstd" ];
    "/nix".options = [ "compress=zstd" "noatime" ];
  };

  programs.dconf.enable = true;

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
#  nix.settings.system-features = [
#    "gccarch-broadwell"
#    "benchmark"
#    "big-parallel"
#    "kvm"
#    "nixos-test"
#  ];

  # nvidia stuff from nixos wiki
  nixpkgs.config.allowUnfree = true;
  services.xserver.videoDrivers = [ "nvidia" ];
  hardware.opengl.enable = true;
  hardware.nvidia.package = config.boot.kernelPackages.nvidiaPackages.stable;
  hardware.nvidia.modesetting.enable = true;
  # end nvidia stuff

  nix.settings.system-features = [ "gccarch-broadwell" "benchmark" "big-parallel" "ca-derivations" "kvm" "nixos-test" ];
  nixpkgs.hostPlatform = {
    gcc.arch = "broadwell";
    gcc.tune = "broadwell";
    system = "x86_64-linux";
  };
  nixpkgs.config.permittedInsecurePackages = [
    "googleearth-pro-7.3.4.8248"
  ];
  nixpkgs.config.packageOverrides = pkgs: {
    haskellPackages = pkgs.haskellPackages.override {
      overrides = self: super: {
        cryptonite = pkgs.haskell.lib.dontCheck super.cryptonite;
        tls = pkgs.haskell.lib.dontCheck super.tls;
        x509 = pkgs.haskell.lib.dontCheck super.x509;
        x509-validation = pkgs.haskell.lib.dontCheck super.x509-validation;
      };
    };
    pythonPackages = pkgs.pythonPackages.override {
      overrides = self: super: {
        scipy = super.scipy.overridePythonAttrs(old: {
          preConfigure = ''
            substituteInPlace meson.build --replace "openblas" "mkl"
          '';
          doCheck = false;
        });
      };
    };
  };
  nixpkgs.config.allowUnsupportedSystem = true;
  nixpkgs.overlays = [                          # This overlay will pull the latest version of Discord
    (self: super: {
      # fails on broadwell
      bind = super.bind.overrideAttrs ( _: { doCheck = false; } );
      # openexr tests: testOptimizedInterleavePatterns # failes on broadwell
      openexr_3 = super.openexr_3.overrideAttrs ( _: { doCheck = false; } );
      #lapack = super.lapack.override { lapackProvider = super.mkl; };
      #blas = super.blas.override { blasProvider = super.mkl; };
      discord = super.discord.overrideAttrs (
        _: { src = builtins.fetchTarball {
          url = "https://discord.com/api/download?platform=linux&format=tar.gz"; 
          sha256 = "1pw9q4290yn62xisbkc7a7ckb1sa5acp91plp2mfpg7gp7v60zvz";
        };}
      );
    })
  ];
}
