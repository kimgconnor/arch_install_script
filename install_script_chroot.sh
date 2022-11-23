#/bash/sh

echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen
locale-gen
echo "LANG=en_US.UTF-8" >> /etc/locale.conf
read -p "what would you like the system hostname to be: " hostname
echo $hostname >> /etc/hostname
echo "please set the root password"
passwd

adduser(){
  useradd $1 -m -G $2
  passwd $1
  read -n1 -p "Add Another User[N,y]: " anotherUser
  case $anotherUser in
    y|Y) read -p "Name of New User: " userName
      read -p "Groups for new user(wheel,audio,video,etc): " userGroups
      adduser $userName $userGroups;;
    n|N) echo "done adding users";;
    *) echo "done adding users";;
    esac
}

read -p "Name of New User(with sudo access): " userName
read -p "Groups for new user with sudo access(audio,video,etc): " userGroups
adduser $userName $userGroups,wheel

#change file permissions for sudo config
chown -c root:root /etc/sudoers
chmod -c 0440 /etc/sudoers

#install bootloader
pacman -S grub efibootmgr
grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=$hostname

#installApps
echo "must swap to user to install packages from the aur"
read -p "whcih user would you like to swap to(must have sudo access): " userSwap
su $userSwap ./install_script_apps.sh
exit
