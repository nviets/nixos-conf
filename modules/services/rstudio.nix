{ config, lib, pkgs, ... }:
let
#  kernelshap = with pkgs;
#    rPackages.buildRPackage {
#      name = "kernelshap";
#      src = fetchFromGitHub {
#        owner = "mayer79";
#        repo = "kernelshap";
#        rev = "962b01222cbc959eff80ecbcecea505f7fc79a74";
#        sha256 = "sha256-Bshf3S0Q8QUjs1o0e06mweybX2IjzPc1ngue7AhD4rc=";
#      };
#      propagatedBuildInputs = with rPackages; [ doRNG foreach MASS ];
#    };
#  shapviz = with pkgs;
#    rPackages.buildRPackage {
#      name = "shapviz";
#      src = fetchFromGitHub {
#        owner = "mayer79";
#        repo = "shapviz";
#        rev = "a5a721b96a034dec01087db85e673155c7d382cc";
#        sha256 = "sha256-rZVCva28HSgx6zLkZGd224PoQU1tphEGkYm5RB8tZZd=";
#      };
#      propagatedBuildInputs = with rPackages; [
#        ggbeeswarm
#        ggfittext
#        gggenes
#        ggplot2
#        ggrepel
#        rlang
#        xgboost
#      ];
#    };
    catboost = with pkgs; rPackages.buildRPackage {
      name = "catboost";
      src = fetchFromGitHub {
        owner = "catboost";
        repo = "catboost";
        rev = "v1.1.1";
        sha256 = "sha256-bqnUHTTRan/spA5y4LRt/sIUYpP3pxzdN/4wHjzgZVY=";
      };
      preBuild = ''
        cd catboost/R-package
      '';
      propagatedBuildInputs = with rPackages; [ jsonlite ];
    };
in {
  networking.firewall = {
    enable = true;
    allowedTCPPorts = [ 8787 ];
  };
  services.rstudio-server = with pkgs; {
    enable = true;
    listenAddr = "192.168.0.236";
    package = rstudioServerWrapper.override {
      packages = [
        (with rPackages; [
          #arrow
          #catboost
          chronicler
          clustermq
          gbm
          ICEbox
          influxdbclient
          innsight
          kernelshap
          knitr
          lightgbm
          lubridate
          luz
          #mirai
          #nanonext
          plotly
          pmml
          quantmod
          recipes
	  rmarkdown
          shapviz
          shiny
          sparklyr
          tabnet
          targets
          tidymodels
          tidyverse
	  tinytex
          torch
          #torchaudio
          torchvision
	  vitae
          xgboost
          XML
          xml2
          xts
          yardstick
        ])
      ];
    };
  };
}
