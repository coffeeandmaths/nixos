{ config, pkgs, ... }:

{
  #-----------------GIT--------------------------
  programs.git = {
    enable = true;

    userName = "nixos_u0";
    userEmail = "mail@nixos.com";

    aliases = {
      dotbackup = "!cd ~/.dotfiles && git add . && git commit -m \"Backup $(date '+%F %T')\" && git push";
    };

    extraConfig = {
      init.defaultBranch = "main";
      safe.directory = "/home/nixos_u0/.dotfiles";
    };
  };
}
