#!/bin/bash
echo
echo "The following program will execute multiple commands in your terminal. Are you sure you want to continue?"
echo
echo "Total Dowloand Size: 2.67 GiB"
echo
read -p ": : Proceed with installation? [y/N] " yn

if [[ "$yn" != "y" && "$yn"  != "Y" ]]; then
  echo "Denied"
  exit 0

fi

pkg update
pkg install pulseaudio -y
pkg install x11-repo -y
pkg install termux-x11-nightly -y
pkg install proot-distro -y
proot-distro install danhunsaker/archlinuxarm:20260517
proot-distro login archlinuxarm -- bash -c "
sed -i 's/^#DownloadUser = alpm/DownloadUser = alpm/' /etc/pacman.conf

mv /usr/bin/pacman /usr/bin/pacman-real

cat > /usr/bin/pacman <<'EOF'
#!/bin/bash
/usr/bin/pacman-real --disable-sandbox "$@"
EOF

chmod +x /usr/bin/pacman

pacman -Sy
echo -e '1\ny' | pacman -Syu
pacman -S --needed --noconfirm xfce4
pacman -S --noconfirm sudo
useradd -m -G wheel Snowyy
echo "Snowyy:10109999aa" | chpasswd
sed -i '/^root ALL=(ALL:ALL) ALL$/a Snowyy ALL=(ALL:ALL) ALL' /etc/sudoers"
wget https://raw.githubusercontent.com/LinuxDroidMaster/Termux-Desktops/refs/heads/main/scripts/proot_arch/startxfce4_arch.sh
sed -i 's/droidmaster/Snowyy/g' startxfce4_arch.sh
chmod +x startxfce4_arch.sh
./startxfce4_arch.sh