#
#  General Home-manager configuration
#
#  flake.nix
#   ├─ ./hosts
#   │   └─ home.nix *
#   └─ ./modules
#       ├─ ./editors
#       │   └─ default.nix
#       ├─ ./programs
#       │   └─ default.nix
#       ├─ ./services
#       │   └─ default.nix
#       └─ ./shell
#           └─ default.nix
#

{ config, lib, pkgs, user, ... }:

{ 
  imports =                                   # Home Manager Modules
    (import ../modules/editors) ++
    (import ../modules/programs) ++
    (import ../modules/services) ++
    (import ../modules/shell);

  home = {
    username = "${user}";
    homeDirectory = "/home/${user}";

    packages = with pkgs; [
      # Terminal
      htop
      btop              # Resource Manager
      gotop             # Resource Manager
      pfetch            # Minimal fetch
      ranger            # File Manager
      tmux              # terminal windows
      lsof
      
      # Video/Audio
      feh               # Image Viewer
      #mpv               # Media Player
      #pavucontrol       # Audio control
      #plex-media-player # Media Player
      vlc               # Media Player
      #stremio           # Media Streamer

      # Apps
      appimage-run      # Runs AppImages on NixOS
      aria2
      #firefox           # Browser
      #google-chrome     # Browser
      nodejs
      remmina           # XRDP & VNC Client
      wol               # wake on lan

      # File Management
      #okular            # PDF viewer
      git-lfs
      gnome.file-roller # Archive Manager
      jq                # json formatting
      ncdu              # File Manager
      nix-tree          # nix store trees
      nixfmt
      nixpkgs-fmt
      nixpkgs-review
      pcmanfm           # File Manager
      rsync             # Syncer $ rsync -r dir1/ dir2/
      unzip             # Zip files
      #unrar             # Rar files

      # General configuration
      #git              # Repositories
      dmidecode
      killall          # Stop Applications
      #nano             # Text Editor
      bintools-unwrapped # utilities
      #pciutils         # Computer utility info
      #pipewire         # Sound
      #usbutils         # USB utility info
      #wacomtablet      # Wacom Tablet
      wget             # Downloader
      #zsh              # Shell
      #
      # General home-manager
      #alacritty        # Terminal Emulator
      #dunst            # Notifications
      #doom emacs       # Text Editor
      #flameshot        # Screenshot
      #libnotify        # Dep for Dunst
      #neovim           # Text Editor
      #rofi             # Menu
      #udiskie          # Auto Mounting
      #vim              # Text Editor
      #
      # Xorg configuration
      #xclip            # Console Clipboard
      #xorg.xev         # Input viewer
      #xorg.xkill       # Kill Applications
      #xorg.xrandr      # Screen settings
      #xterm            # Terminal
      #
      # Xorg home-manager
      #picom            # Compositer
      #polybar          # Bar
      #sxhkd            # Shortcuts
      #
      # Wayland configuration
      #autotiling       # Tiling Script
      #swayidle         # Idle Management Daemon
      #wev              # Input viewer
      #wl-clipboard     # Console Clipboard
      #
      # Wayland home-manager
      #pamixer          # Pulse Audio Mixer
      #swaylock-fancy   # Screen Locker
      #waybar           # Bar
      #
      # Desktop
      #blueman          # Bluetooth
      #deluge           # Torrents
      #discord          # Chat
      #ffmpeg           # Video Support (dslr)
      #gmtp             # Mount MTP (GoPro)
      #gphoto2          # Digital Photography
      #handbrake        # Encoder
      #heroic           # Game Launcher
      #hugo             # Static Website Builder
      #lutris           # Game Launcher
      #mkvtoolnix       # Matroska Tool
      #new-lg4ff        # Logitech Drivers
      #plex-media-player# Media Player
      #polymc           # MC Launcher
      #steam            # Games
      #simple-scan      # Scanning
      # 
      # Laptop
      #blueman          # Bluetooth
      #light            # Display Brightness
      #libreoffice      # Office Tools
      #simple-scan      # Scanning
      #
      # Flatpak
      #obs-studio       # Recording/Live Streaming
    ];
    file.".config/wall".source = ../modules/themes/wall;
    pointerCursor = {                         # This will set cursor systemwide so applications can not choose their own
      name = "Dracula-cursors";
      package = pkgs.dracula-theme;
      size = 16;
    };
    stateVersion = "23.05";
  };

  programs = {
    home-manager.enable = true;
  };

  nixpkgs.config.allowUnfree = true;

  gtk = {                                     # Theming
    enable = true;
    theme = {
      name = "Dracula";
      package = pkgs.dracula-theme;
    };
    iconTheme = {
      name = "Papirus-Dark";
      package = pkgs.papirus-icon-theme;
    };
    font = {
      name = "JetBrains Mono Medium";         # or FiraCode Nerd Font Mono Medium
    };                                        # Cursor is declared under home.pointerCursor
  };
}
