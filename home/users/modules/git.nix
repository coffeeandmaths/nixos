{congig,pkgs, ...}:
{
  #-----------------GIT--------------------------
  programs.git = {
    enable = true;
    userName = "nixos_u0";
    userEmail = "mail@nixos.com";
    extraConfig = {
      init.defaultBranch = "main";
      safe.directory = "$HOME/nixos_u0/dotfiles";
    };
  };
}
