## Booting and Logging 
You are logged-in automatically as nixos. The nixos user account has an empty password so you can use sudo without a password:
```
sudo -i
```
You can use **loadkeys** to switch to your preferred keyboard layout. 
## Networking

To configure the wifi, first start wpa_supplicant with s**udo systemctl start wpa_supplicant**, then run **wpa_cli**. For most home networks, you need to type in the following commands:
```
> add_network
0

> set_network 0 ssid "myhomenetwork"
OK

> set_network 0 psk "mypassword"
OK

> enable_network 0
OK

```

## Partiioning

Create a MBR partition table.
```
parted /dev/sda -- mklabel msdos
```
Add the root partition. This will fill the the disk except for the end part, where the 
swap will live.
```
parted /dev/sda -- mkpart primary 1MB -8GB
```
Set the root partition’s boot flag to on. This allows the disk to be booted from.
```
parted /dev/sda -- set 1 boot on
```
Finally, add a swap partition. The size required will vary according to needs, here a 8GB one is created.
```
parted /dev/sda -- mkpart primary linux-swap -8GB 100%
```
### Formatting
```
mkfs.ext4 -L nixos /dev/sda1
mkswap -L swap /dev/sda2
```

## Installing 

```
mount /dev/disk/by-label/nixos /mnt
swapon /dev/sda2
nixos-generate-config --root /mnt
nano /mnt/etc/nixos/configuration.nix
(Add : boot.loader.grub.device


```



