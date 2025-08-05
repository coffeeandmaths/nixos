{ config, pkgs, lib, ... }:

{
  # Enable PLASMA 6 desktop

    services.xserver.enable = true;
    services.displayManager.sddm.enable = true;
    services.displayManager.sddm.wayland.enable = true;
    services.desktopManager.plasma6.enable = true;


  environment.plasma6.excludePackages = with pkgs.kdePackages; [
  plasma-browser-integration
  oxygen
];

  # Optional: Additional PLASMA packages
  environment.systemPackages = with pkgs; [
  kdePackages.partitionmanager
  kdePackages.isoimagewriter
  kdePackages.kwalletmanager  # GUI to manage KWallets
  kdePackages.kwallet         # KWallet daemon
  ];
   # Enables PAM integration to unlock KWallet automatically on login
  security.pam.services.sddm.enableKwallet = true;

  # System-wide KDE Wallet preferences
  environment.etc."xdg/kwalletrc".text = ''
    [Wallet]
    Enabled=true
    First Use=false
    Default Wallet=kdewallet
  '';
}
