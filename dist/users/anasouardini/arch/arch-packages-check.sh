#!/bin/bash

apps="rsync bluez bluez-tools pulseaudio-module-bluetooth pipewire pipewire-pulse network-manager wget curl arp-scan sshfs netplan.io proftpd hping3 build-essential libx11-dev gcc make cmake xorg xinput arandr xdo xdotool xclip xbanish git vlc yt-dlp flameshot simplescreenrecorder zathura zathura-pdf-poppler mpd ncmpcpp mpc sxiv gimp ripgrep btop fd-find ncdu bat tldr rsync bc tree trash-cli rename whois fzf dosfstools sgdisk lvm2 smartmontools timeshift adb fastboot docker.io docker-compose qemu-system libvirt-daemon-system libvirt-clients qemu-utils ovmf virtinst virt-manager virt-viewer firejail ufw tor proxychains pass pinentry-qt policykit-1-gnome dbus-x11 notification-daemon libnotify-bin dunst pulseaudio alsa-utils pavucontrol i3 polybar suckless-tools sxhkd ranger alacritty chromium brave-browser google-chrome-stable thunderbird mysql sqlite3 zsh zsh-autosuggestions zsh-syntax-highlighting";


# sudo pacman -S qemu-full virt-manager virt-viewer dnsmasq bridge-utils libguestfs ebtables vde2 gnu-netcat
# sudo usermod -aG libvirt $(whoami)
# sudo systemctl enable --now libvirtd

# echo "---------- APPS that don't exist in arch:"
# for app in $apps; do
#     exists=$(sudo pacman -Ssq $app | grep "$app");

#     if [[ -z $exists ]]; then
#         exists=$(sudo yay -Ssq $app | grep "$app");
#         if [[ -z $exists ]]; then
#             echo $app
#         fi
#     fi
# done

## -------------- not found
# pulseaudio-module-bluetooth => pulseaudio
# netplan.io => netplan
# hping3 => hping
# build-essential => base-devel
# libx11-dev => libx11
# fd-find => fd
# fastboot => android-tools
# docker.io => docker
# libvirt-daemon-system => qemu
# libvirt-clients => qemu
# qemu-utils => qemu
# virtinst => virt-manager
# pinentry-qt => pinentry
# policykit-1-gnome => polkit
# brave-browser => brave
# google-chrome-stable => google-chrome
# plexmediaserver => plex-media-server
# libnotify-bin => libnotify
# suckless-tools => dmenu

altApps="pulseaudio netplan hping gcc libx11 fd gptfdisk android-tools docker qemu virt-manager pinentry polkit brave google-chrome plex-media-server libnotify dmenu";
echo "----------- Alt Apps that dont exist in arch:"
for app in $altApps; do
    exists=$(sudo pacman -Ssq $app | grep "$app");
    if [[ -z $exists ]]; then
        exists=$(sudo yay -Ssq $app | grep "$app");
        if [[ -z $exists ]]; then
            echo $app
        fi
    fi
done