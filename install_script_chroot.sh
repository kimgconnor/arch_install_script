#/bash/sh

echo "please uncomment your locale(likely to be en_US.UTF-8 UTF-8)"
sleep 3
nano /etc/locale.gen
locale-gen
echo "LANG=en_US.UTF-8" >> /etc/locale.conf
read -p "what would you like the system hostname to be: " hostname
echo $hostname >> /etc/hostname
echo "please set the root password"
sleep 1
passwd
bootctl install

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

read -n1 -p "Install Paru[Y, n]: " installParu
echo ""
#install paru
case $installParu in
  y|Y) installParuFunction ;;
  n|N) echo 'paru install skiped' ;;
  *) installParuFunction ;;
esac

#installApps
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
