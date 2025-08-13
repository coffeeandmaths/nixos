# NixOS Install Script from Minimal ISO (BIOS + Plasma + Dotfiles)

This guide explains how to install NixOS from the minimal ISO, connect to Wi-Fi, prepare the disk, copy your SSH key from USB, clone your dotfiles, and deploy the flake.

> **Target system:** BIOS boot with GRUB, Plasma desktop from this flake.

---

## Step-by-Step Install

Boot from the NixOS minimal ISO and run the following commands in order.

### 1. Connect to Wi-Fi
```bash
sudo systemctl start wpa_supplicant
ip link        # find your Wi-Fi interface, e.g., wlan0
iwlist <wifi-interface> scan | grep ESSID
wpa_passphrase "SSID_NAME" "your_password" | sudo tee /etc/wpa_supplicant.conf
wpa_supplicant -B -i <wifi-interface> -c /etc/wpa_supplicant.conf
dhclient <wifi-interface>
ping -c 3 nixos.org
