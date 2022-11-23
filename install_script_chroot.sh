#/bash/sh

echo "please uncomment your locale(likely to be en_US.UTF-8 UTF-8)"
sleep 3
echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen
locale-gen
echo "LANG=en_US.UTF-8" >> /etc/locale.conf
read -p "what would you like the system hostname to be: " hostname
echo $hostname >> /etc/hostname
echo "please set the root password"
sleep 1
passwd
bootctl install

adduser(){
  useradd $1 -G $2
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
read -p "Groups for new user(wheel,audio,video,etc): " userGroups
adduser $userName $userGroups;;

#copy basic config to allow wheel group to sudo
mv ./sudoers /etc/
chown -c root:root /etc/sudoers
chmod -c 0440 /etc/sudoers

#installApps
echo "must swap to user to install packages from the aur"
read -p "whcih user would you like to swap to(must have sudo access): " userSwap
su $userSwap ./install_script_apps.sh
exit
