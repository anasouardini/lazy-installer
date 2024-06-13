#!/usr/bin/env bash

## config
bootType="bios"; # uefi/bios

setfont ter-v22n

lsblk
read -p "Insert the name of your disk (sda, sdb, etc):" DISK
if [[ -z $DISK ]]; then
    printf "Can't leave the name emtpy!"
    exit 1
fi
DISK="/dev/$DISK"

printf "\n=================== Partitioning\n"
if [[ $bootType == "uefi" ]]; then
    sudo parted "$DISK" -- mklabel gpt
    sudo parted "$DISK" -- mkpart root ext4 512MB -12GiB
    sudo parted "$DISK" -- mkpart swap linux-swap -12GiB 100%
    sudo parted "$DISK" -- mkpart ESP fat32 1MiB 512MiB
    sudo parted "$DISK" -- set 3 esp on
else
    sudo parted "$DISK" -- mklabel msdos
    sudo parted "$DISK" -- mkpart primary ext4 1MB -12GiB
    sudo parted "$DISK" -- set 1 boot on
    sudo parted "$DISK" -- mkpart primary linux-swap -12GiB 100%
fi

printf "\n=================== Formatting\n"
sudo mkfs.ext4 -L nixos "${DISK}1"
sudo mkswap -L swap "${DISK}2"
if [[ $bootType == "uefi" ]]; then
    sudo mkfs.fat -F 32 -n boot "${DISK}3"
fi

printf "\n=================== Mounting\n"
sudo mount /dev/disk/by-label/nixos /mnt
if [[ $bootType == "uefi" ]]; then
    sudo mkdir -p /mnt/boot
    # sudo mount /dev/disk/by-label/boot /mnt/boot
    sudo mount -o umask=077 /dev/disk/by-label/boot /mnt/boot
fi
sudo swapon "${DISK}${NAME_DIVIDER}2"

printf "\n=================== Generating config files\n"
sudo nixos-generate-config --root /mnt
sudo mv /mnt/etc/nixos/configuration.nix /mnt/etc/nixos/configuration.nix.bak
sudo curl -o /mnt/etc/nixos/configuration.nix https://postinstaller.netlify.app/users/sample/nixos/configuration.nix

printf "\n=================== Final Steps\n"
if [[ $bootType == "uefi" ]]; then
    ## for Grub
    # boot.loader.grub.device="nodev";
    # boot.loader.grub.efiSupport=true;

    ## for systemd-boot
    # boot.loader.systemd-boot.enable

    printf "" # can't do empty blocks in bash
else
    # boot.loader.grub.device="/dev/${DISK}1";
    # boot.loader.grub.useOSProber=true;
    printf "" # can't do empty blocks in bash
fi

printf "\n=================== Installing\n"
sudo nixos-install --no-root-passwd

# Might not be needed since most things can be done by
# just dropping a config file to the target disk ¯\_(ツ)_/¯
# printf "\n=================== Preparing the chroot environment\n"
# sudo mount --bind /proc /mnt/proc
# sudo mount --bind /dev /mnt/dev
# sudo mount --bind /sys /mnt/sys
# sudo cp /etc/resolv.conf /mnt/etc/resolv.conf # dns might not be sat correctly (it's a common problem)
# chroot /mnt /nix/var/nix/profiles/system/activate
# chroot /mnt /run/current-system/sw/bin/bash