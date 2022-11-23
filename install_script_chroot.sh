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

#installParu function
installParuFunction() {
  cd
  sudo pacman -Syyu --needed base-devel
  git clone https://aur.archlinux.org/paru.git
  cd paru
  makepkg -si
  echo "Installed Paru"
  cd
  read -n1 -p "Remove Paru Build Files[Y, n]: " deleteParuDirectory
  echo ""
  case $installParu in
    y|Y) #rm -rf./paru
    echo "Removed Paru Directory" ;;
    n|N) echo 'paru install skiped' ;;
    *) #rm -rf./paru
    echo "Removed Paru Directory" ;;
    esac
}

#installApps functions
installAppsFunction() {
  read -n1 -p "install $1[Y, n]:" installApp
  echo ""
  case $installApp in
    y|Y) paru -S $1
    echo "test";;
    n|N) echo "$1 skipped" ;;
    *) echo "$1 skipped" ;;
  esac
}

installOtherAppsFunction() {
    read -p "what other packages would you like to install(None to stop): " installOtherApp
    case $installOtherApp in
        none|None|NONE) echo "done installing other packages" ;;
        *) installAppsFunction $installOtherApp
            installOtherAppsFunction ;;
    esac
}

read -p "Name of New User(with sudo access): " userName
read -p "Groups for new user(wheel,audio,video,etc): " userGroups
adduser $userName $userGroups;;

read -n1 -p "Install Paru[Y, n]: " installParu
echo ""
#install paru
case $installParu in
  y|Y) installParuFunction ;;
  n|N) echo 'paru install skiped' ;;
  *) installParuFunction ;;
esac

#copy basic config to allow wheel group to sudo
mv ./sudoers /etc/
chown -c root:root /etc/sudoers
chmod -c 0440 /etc/sudoers

#installApps
echo "must swap to user to install packages from the aur"
read -p "whcih user would you like to swap to(must have sudo access): " userSwap
su $userSwap
installAppsFunction 'steam' ;
installAppsFunction 'discord' ;
installAppsFunction 'flatpak' ;
installAppsFunction 'snapd' ;
installAppsFunction 'firefox' ;
installAppsFunction 'firedragon' ;
installAppsFunction 'alacritty' ;
installAppsFunction 'xterm' ;
installAppsFunction 'kitty' ;
installAppsFunction 'picom' ;
installAppsFunction 'kate' ;
installAppsFunction 'atom' ;
installAppsFunction 'emacs' ;
installAppsFunction 'qtile' ;
installAppsFunction 'xmonad' ;
installAppsFunction 'plasma' ;
installAppsFunction 'gnome' ;
installAppsFunction 'xfce4' ;
installAppsFunction 'xfce4-devel' ;
installAppsFunction 'mesa' ;
installAppsFunction 'nvidia' ;
installAppsFunction 'corectrl' ;
installAppsFunction 'gwe' ;
installAppsFunction 'multimc';
installAppsFunction 'prismlauncher' ;
installAppsFunction 'minecraft-launcher' ;
installAppsFunction 'dolphin' ;
installAppsFunction 'thunar' ;
installAppsFunction 'thunar-devel' ;
installAppsFunction 'nemo'
installAppsFunction 'p7zip'
installAppsFunction '7z' ;
installOtherAppsFunction
exit
exit
