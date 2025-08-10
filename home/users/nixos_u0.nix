{ config, pkgs, ... }:

{

  home.username = "nixos_u0";
  home.homeDirectory = "/home/nixos_u0";
  home.stateVersion = "25.05";
  systemd.user.startServices = "sd-switch";
  imports = [

#    ../modules/starship.nix
#     ../modules/bash.nix
      ./modules/bash.nix
      ./modules/git.nix




  ];
  home.packages = with pkgs; [
nerd-fonts.jetbrains-mono
  powerline-fonts
  gyre-fonts
    firefox
    texlive.combined.scheme-full
    tectonic
    obsidian
    pdf2svg
    libreoffice
    texstudio
    vscode
#    sage
   pandoc
#   quarto
#    (python3.withPackages (ps: with ps; [
#      manim
#      numpy
#      scipy
#      pillow
#    ]))
#    ffmpeg
   ];



 }
