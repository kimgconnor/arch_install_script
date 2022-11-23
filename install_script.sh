#/bash/sh

clear

formatBootPartition() {
  case $1 in
    y|Y) mkfs.fat -F 32 $2;;
    n|N) ;;
    *) echo "invalid answer"
    read -n1 -p "do you need to format the efi partition(only do this if it isnt being used by another os already)[y,n]" formatEFI
    formatBootPartition ;;
  esac
}

#archinstall
timedatectl status
fdisk -l
read -p "Which Disk would you like it to format: " disk1
clear
fdisk $disk1 --list
fdisk $disk1
read -p "which partition would you like to use for /boot(/dev/sdXy): " bootPartition
read -p "which partition would you like to use for /home(/dev/sdXy): " homePartition
read -p "which partition would you like to use for /(/dev/sdXy): "     rootPartition
read -n1 -p "would you like to use a swap partition[n, Y]"  swapEnabled
case $swapEnabled in
  y|Y) read -p "which partition would you like to use for swap(/dev/sdXy): " swapPartition
    mkswap $swapPartition ;;
  n|N) echo "swap not enabled" ;;
  *) read -p "which partition would you like to use for swap(/dev/sdXy): " swapPartition
    mkswap $swapPartition ;;
esac
read -p "partitionType for / and /home(btrfs, ext4, xfs, etc): " partitionType
mkfs.$partitionType $homePartition
mkfs.$partitionType $rootPartition
read -n1 -p "do you need to format the efi partition(only do this if it isnt being used by another os already)[y,n]" formatEFI
formatBootPartition $formatEFI $bootPartition
mount --mkdir $rootPartition /mnt
mount --mkdir $homePartition /mnt/home
mount --mkdir $bootPartition /mnt/boot

reflector
pacstrap -K /mnt base linux linux-firmware nano git
genfstab -U /mnt >> /mnt/etc/fstab
cp ./install_script_chroot.sh /mnt
cp ./install_script_apps.sh /mnt
cp ./sudoers /mnt/etc
chmod u+x /mnt/install_script_chroot.sh
chmod u+x /mnt/install_script_apps.sh
arch-chroot /mnt ./install_script_chroot.sh
echo "arch install complete"
read -n1 -p "would you like to delete the install scripts[n, Y]" removeScripts
case $removeScripts in
  n|N) exit ;;
  *) rm install_script.sh
    rm install_script_chroot.sh
    rm /mnt/install_script_chroot.sh
