# README.md — NixOS Install (Minimal ISO → Dotfiles → Plasma)

This guide lets you install NixOS from the **minimal ISO**, connect to Wi-Fi, partition/format, copy an SSH key from a USB, clone your dotfiles, and deploy your flake to get Plasma running.

> **Assumptions:** Legacy **BIOS** (GRUB) + **ext4** root. Adjust device names (`/dev/sdX`), SSID, usernames, and repo paths as needed.

---

## Install — copy/paste these commands in order

```bash
# === Wi-Fi (on the minimal ISO) ===
# Option A: direct wpa_supplicant (works everywhere)
sudo systemctl start wpa_supplicant
ip link                       # find your Wi-Fi interface, e.g. wlan0 / wlp2s0
iwlist <wifi-iface> scan | grep ESSID
wpa_passphrase "YOUR_SSID" "YOUR_WIFI_PASSWORD" | sudo tee /etc/wpa_supplicant.conf
wpa_supplicant -B -i <wifi-iface> -c /etc/wpa_supplicant.conf
dhclient <wifi-iface>
ping -c 3 nixos.org

# (Optional) Option B: interactive
# nmtui  # connect and ensure you have internet

# === Disk partitioning (BIOS example on /dev/sda) ===
lsblk
cfdisk /dev/sda
# In cfdisk create:
#   /dev/sda1  1G     Linux filesystem  -> will be /boot (ext4)
#   /dev/sda2  rest   Linux filesystem  -> will be /     (ext4)

# === Filesystems ===
mkfs.ext4 -F /dev/sda1
mkfs.ext4 -F /dev/sda2

# === Mount target ===
mount /dev/sda2 /mnt
mkdir -p /mnt/boot
mount /dev/sda1 /mnt/boot

# === Generate initial config for THIS machine ===
nixos-generate-config --root /mnt

# === Copy your SSH private key from USB (temporary for root) ===
# Plug your USB; identify it as, e.g., /dev/sdb1
lsblk
mkdir -p /mnt-usb
mount /dev/sdb1 /mnt-usb
mkdir -p /mnt/root/.ssh
cp /mnt-usb/id_ed25519 /mnt/root/.ssh/
chmod 700 /mnt/root/.ssh
chmod 600 /mnt/root/.ssh/id_ed25519

# === Base install (minimal, just to boot) ===
nixos-install
# Set a root password when prompted.
reboot
```

```bash
# === After reboot: log in as root and create your user ===
useradd -m -G wheel -s /bin/bash <youruser>
passwd <youruser>
EDITOR=nano visudo    # uncomment the line:   %wheel ALL=(ALL) ALL

# === After reboot: log in as root and create your user ===
useradd -m -G wheel -s /bin/bash <youruser>
passwd <youruser>
EDITOR=nano visudo    # uncomment the line:   %wheel ALL=(ALL) ALL

# Enable NetworkManager so Wi-Fi can be managed persistently
nixos-rebuild switch --impure -I nixpkgs=channel:nixos-24.05 \
  -p "services.networkmanager.enable = true;"
systemctl enable NetworkManager
systemctl start NetworkManager

# (Optional) Connect to Wi-Fi now via text UI
nmtui

# Move the SSH key from root to your user
mkdir -p /home/<youruser>/.ssh
mv /root/.ssh/id_ed25519 /home/<youruser>/.ssh/
chown -R <youruser>:<youruser> /home/<youruser>/.ssh
chmod 700 /home/<youruser>/.ssh
chmod 600 /home/<youruser>/.ssh/id_ed25519

# Switch to your user session
su - <youruser>

# === Test GitHub SSH and clone your dotfiles ===
ssh -T git@github.com            # should say "Hi <user>! You've successfully authenticated..."
git clone git@github.com:<your-user>/<your-dotfiles-repo> ~/.dotfiles

# === Make host match your flake target and deploy ===
sudo hostnamectl set-hostname <hostname-in-flake>
cd ~/.dotfiles
sudo nixos-rebuild switch --flake .#<hostname-in-flake> -L

# Reboot into your configured Plasma system
sudo reboot



# Move the SSH key from root to your user
mkdir -p /home/<youruser>/.ssh
mv /root/.ssh/id_ed25519 /home/<youruser>/.ssh/
chown -R <youruser>:<youruser> /home/<youruser>/.ssh
chmod 700 /home/<youruser>/.ssh
chmod 600 /home/<youruser>/.ssh/id_ed25519

# Switch to your user session
su - <youruser>

# === Test GitHub SSH and clone your dotfiles ===
ssh -T git@github.com            # should say "Hi <user>! You've successfully authenticated..."
git clone git@github.com:<your-user>/<your-dotfiles-repo> ~/.dotfiles

# === Make host match your flake target and deploy ===
sudo hostnamectl set-hostname <hostname-in-flake>
cd ~/.dotfiles
sudo nixos-rebuild switch --flake .#<hostname-in-flake> -L

# Reboot into your configured Plasma system
sudo reboot
```

---

## Recovery (if the new generation doesn’t boot)

```bash
# Boot the minimal ISO, then:
lsblk
mount /dev/sda2 /mnt
mount /dev/sda1 /mnt/boot
nixos-enter -r /mnt
# Roll back or boot an older generation:
ls -ltr /nix/var/nix/profiles | grep system-
/nix/var/nix/profiles/system-*-link/bin/switch-to-configuration boot
```

---

## Notes

- Adjust `/dev/sda` → your actual disk. Laptop NVMe may be `/dev/nvme0n1` with partitions `/dev/nvme0n1p1`, `/dev/nvme0n1p2`.
- For **UEFI**, create an EFI partition (FAT32, ~512 MiB, type EF00) mounted at `/boot/efi`, and enable `systemd-boot` in your flake.  
- For **Btrfs/ZFS/LUKS**, ensure matching `fileSystems` entries, `boot.initrd.supportedFilesystems`, and (for LUKS) `boot.initrd.luks.devices` in your flake/host module.
- Always regenerate `hardware-configuration.nix` when moving to new hardware:
  ```bash
  nixos-generate-config --root /mnt
  ```
- Keep multiple generations by setting `configurationLimit` in your chosen bootloader.
