{ config, lib, pkgs, ... }:
 {

 # Enable CUPS printing
     services.printing.enable = true;

   # Use HPLIP with the plugin for HP support (e.g., scanning or proprietary features)
     services.printing.drivers = [ pkgs.hplipWithPlugin ];
     services.printing.browsing = true;
     services.printing.defaultShared = true;
     # Optional but recommended
     hardware.printers.ensurePrinters = [];
   # Enable scanner support
     hardware.sane.enable = true;

   # Allow network printer discovery via mDNS/Avahi
     services.avahi = {
      enable = true;
      nssmdns4 = true;
      openFirewall = true;
     };

   # Allow the CUPS web interface through the firewall
     networking.firewall.allowedTCPPorts = [ 631 ];
}
