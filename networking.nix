{ config, lib, pkgs, ... }:
 {
# Network
  networking.hostName = "nixos"; # Define your hostname.
  networking.networkmanager.wifi.powersave = false;
  networking.networkmanager.enable = true;
  systemd.services.resume-networking = {
  description = "Restart NetworkManager after resume";
  wantedBy = [ "sleep.target" ];
  before = [ "network-online.target" ];
  after = [ "suspend.target" "hibernate.target" "hybrid-sleep.target" ];
  serviceConfig = {
    Type = "oneshot";
    ExecStart = "${pkgs.systemd}/bin/systemctl restart NetworkManager.service";
  };
 };

 }
