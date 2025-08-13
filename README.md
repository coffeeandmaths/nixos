# NixOS Install Guide for My Dotfiles

This document explains how to install NixOS from the **minimal ISO**, connect to Wi-Fi, prepare the disk, copy an SSH key from USB, clone this repository, and deploy the system.

> **Target system**: BIOS boot with GRUB, Plasma desktop from this flake.

---

## 1. Boot Minimal ISO
Download the latest minimal ISO from [nixos.org/download](https://nixos.org/download.html), write it to USB, and boot it.

---

## 2. Connect to Wi-Fi
```bash
# Start Wi-Fi service
sudo systemctl start wpa_supplicant

# Find your wireless interface
ip link

# Scan for networks
iwlist <wifi-interface> scan | grep ESSID

# Connect
wpa_passphrase "SSID_NAME" "your_password" | sudo tee /etc/wpa_supplicant.conf
wpa_supplicant -B -i <wifi-interface> -c /etc/wpa_supplicant.conf

# Get an IP address
dhclient <wifi-interface>

# Test connection
ping nixos.org
