# NixOS Install Script from Minimal ISO (BIOS + Plasma + Dotfiles)

This guide explains how to install NixOS from the minimal ISO, connect to Wi-Fi, prepare the disk, copy an SSH key from USB, clone your dotfiles, and deploy the flake.

> **Target system:** BIOS boot with GRUB, Plasma desktop from this flake.

---

## Install Instructions

Boot from the NixOS minimal ISO and run the following commands **in order**.

```bash
# --- Connect to Wi-Fi ---
sudo systemctl start wpa_supplicant
ip link        # find your Wi-Fi interface, e.g., wlan0
iwlist <wifi-interface> scan | grep ESSID
wpa_passphrase "SSID_NAME" "your_password" | sudo tee /etc/wpa_supplicant.conf
wpa_supplicant -B -i <wifi-interface> -c /etc/wpa_supplicant.conf
dhclient <wifi-interface>
ping -c 3 nixos.org

# Alternatively, use interactive setup:
# nmtui

# --- Partition and format (BIOS example) ---
lsblk
cfdisk /dev/sda
# In cfdisk:
#   - Create /boot (1G, type 83 Linux)
#   - Create / (rest of disk, type 83 Linux)
mkfs.ext4 /dev/sda1
mkfs.ext4 /dev/sda2

# --- Mount target filesystem ---
mount /dev/sda2 /mnt
mkdir /mnt/boot
mount /dev/sda1 /mnt/boot

# --- Generate initial config ---
nixos-generate-config --root /mnt

# --- Copy SSH key from USB (for root use during setup) ---
lsblk   # find USB device, e.g., /dev/sdb1
mkdir /mnt-usb
mount /dev/sdb1 /mnt-usb
mkdir -p /mnt/root/.ssh
cp /mnt-usb/id_ed25519 /mnt/root/.ssh/
chmod 600 /mnt/root/.ssh/id_ed25519

# --- Install minimal NixOS ---
nixos-install
# Set root password when prompted
reboot

# --- After reboot: log in as root and create user ---
useradd -m -G wheel -s /bin/bash <youruser>
passwd <youruser>
EDITOR=nano visudo   # Uncomment "%wheel ALL=(ALL) ALL"

# --- Move SSH key to user ---
mkdir -p /home/<youruser>/.ssh
mv /root/.ssh/id_ed25519 /home/<youruser>/.ssh/
chmod 700 /home/<youruser>/.ssh
chmod 600 /home/<youruser>/.ssh/id_ed25519
chown -R <youruser>:<youruser> /home/<youruser>/.ssh

# --- Clone dotfiles ---
su - <youruser>
ssh -T git@github.com   # should say authenticated
git clone git@github.com:<your-user>/<your-dotfiles-repo> ~/.dotfiles

# --- Deploy flake ---
sudo hostnamectl set-hostname <hostname-in-flake>
cd ~/.dotfiles
sudo nixos-rebuild switch --flake .#<hostname-in-flake> -L

# --- Reboot into configured system ---
sudo reboot
