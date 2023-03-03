#
# Doom Emacs: home-manager alternative in "home.nix". Personally not a fan of github:nix-community/nix-doom-emacs due to performance issues
# recommended to comment out this part on first install because script will cause issues. It your want to use doom emacs, use the correct location or change in script
#
# flake.nix
#   ├─ ./hosts
#   │   └─ configuration.nix
#   └─ ./modules
#       └─ ./editors
#           └─ ./emacs
#               └─ default.nix *
#


{ config, pkgs, doom-emacs, ... }:

{
  imports = [ doom-emacs.hmModule ];

  services.emacs = {
    enable = true;
    #package = doom-emacs;
  };

  programs.doom-emacs = {
    enable = true;
    doomPrivateDir = ./doom.d;
  };

  home.packages = with pkgs; [
    ripgrep
    coreutils
    fd
  ];                                                 # Dependencies
}

# HOME MANAGER ALTERNATIVE

#{ pkgs, ... }:

#{
#  home.file.".doom.d" = {                       # Get Doom Emacs
#    source = ./doom.d;                          # Sets up symlink name ".doom.d" for file "doom.d"
#    recursive = true;                           # Allow symlinking a directory
#    onChange = builtins.readFile ./doom.sh;     # If an edit is detected, it will run this script. Pretty much the same as what is now in default.nix but actually stating the terminal and adding the disown flag to it won't time out
#  };

#  programs = {
#    emacs.enable = true;                        # Get Emacs
#  };
#}

# REFERENCES ./doom.d DIRECTORY

# doom.sh:
#
# #!/bin/sh
# DOOM="$HOME/.emacs.d"
#
# if [ ! -d "$DOOM" ]; then
#   git clone https://github.com/hlissner/doom-emacs.git $DOOM
#   alacritty -e $DOOM/bin/doom -y install & disown
# else
#   alacritty -e $DOOM/bin/doom sync
# fi
#
