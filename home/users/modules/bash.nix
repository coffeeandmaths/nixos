{ pkgs, config, ... }:

{
  programs.bash = {
    enable = true;
    shellAliases = {
      updateg = "cd ${config.home.homeDirectory}/.dotfiles && sudo nixos-rebuild switch --flake .#nixos";
      dotbackup = "cd ${config.home.homeDirectory}/.dotfiles && git add . && git commit -m \"Backup $(date '+%F %T')\" && git push";
      cleang  = "sudo nix-collect-garbage -d";
      ld      = "cd ${config.home.homeDirectory}/.dotfiles";
      flakeup = "cd ${config.home.homeDirectory}/.dotfiles && nix flake update && git add flake.lock && git commit -m 'flake: update inputs' && git push";
      checkg = "cd ${config.home.homeDirectory}/.dotfiles && nixos-rebuild build --flake .#nixos";
      cleancache = "sudo nix store gc";
      nsearch = "nix search nixpkgs";


    };
  };
}
