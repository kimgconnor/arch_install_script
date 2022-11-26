#/bash/sh

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
  read -n1 -p "install $1[y, N]:" installApp
  echo ""
  case $installApp in
    y|Y) paru -S $1
    echo "test";;
    n|N) echo "$1 skipped" ;;
    *) echo "$1 skipped" ;;
  esac
}

installAppsNoConfirmFunction() {
  paru -S $1 --noconfirm
}
installDeamonFunction() {
  installAppsFunction $1
  sudo systemctl enable $1
}

installOtherAppsFunction() {
    read -p "what other packages would you like to install(None to stop): " installOtherApp
    case $installOtherApp in
        none|None|NONE) echo "done installing other packages" ;;
        *) installAppsFunction $installOtherApp
            installOtherAppsFunction ;;
    esac
}

installAppGroupFunction() {
  read -n1 -p "installGroup[y, N]: $1" installGroup
  case $installGroup in
    y|Y) for app in $#-1
      do
        read -n1 -p "install all with no confirmation(may break stuff use at your own risk)[N, y]: " blindinstall
        appNumber = app+1
        case $blindinstall in
          y|Y) installAppsNoConfirmFunction $appNumber ;;
          n|N) installAppsFunction $appNumber ;;
          *) installAppsFunction $appNumber ;;
        esac
      done ;;
    n|N) echo "$1 skipped" ;;
    *) echo "$1 skipped" ;;
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

paru -S networkmanager
sudo systemctl enable NetworkManager

echo "now installing apps"
echo "there will be a 3 sec sleep after saying the next catagory of apps"
echo "this is to allow you to skip past the rest of the apps if you have already installed the ones you want."
sleep 3

#drivers and other important setup
clear
echo "drivers and other important setup"
sleep 3
installAppsFunction 'xorg' ;
installAppsFunction 'wayland' ;
installAppGroupFunction 'pipewire' 'pipewire' 'pipewire-pulse';
installAppsFunction 'pulseaudio' ;
installAppGroupFunction 'amd drivers' 'vulkan-icd-loader' 'lib32-vulkan-icd-loader' 'mesa' 'vulkan-radeon' 'lib32-vulkan-radeon' ;
installAppGroupFunction 'intel drivers' 'mesa' 'vulkan-intel' 'lib32-vulkan-intel' 'vulkan-icd-loader' 'lib32-vulkan-icd-loader';
installAppGroupFunction 'nvidia' 'nvidia' 'nvidia-utils' 'lib32-nvidia-utils' 'vulkan-icd-loader' 'lib32-vulkan-icd-loader' ;

#loginmanagers
clear
echo "display managers(please only install one)"
sleep 3
installDeamonFunction 'gdm' ;
installDeamonFunction 'lightdm' ;
installDeamonFunction 'sddm' ;

#desktop enviornments
clear
echo "desktop enviornments"
sleep 3
installAppsFunction 'budgie-desktop' ;
installAppsFunction 'qtile' ;
installAppsFunction 'xmonad' ;
installAppsFunction 'plasma' ;
installAppGroupFunction 'gnome-desktop' 'gnome' 'gnome-tweak-tool' 'gnome-shell-extensions';
installAppsFunction 'xfce4-devel' ;
installAppsFunction 'xfce4' ;
installAppsFunction 'cutefish' ;
installAppsFunction 'lxde-gtk3';
installAppsFunction 'lxqt' ;
installAppsFunction 'mate' ;
installAppsFunction 'xfce4' ;

#package format tools/installers
clear
echo "package format tools/installers"
sleep 3
installAppsFunction 'flatpak' ;
installAppsFunction 'snapd' ;
installAppsFunction 'appimagelauncher' ;

#browsers and terminals
clear
echo "browsers"
sleep 3
installAppsFunction 'firefox' ;
installAppsFunction 'firedragon' ;
installAppsFunction 'librewolf' ;
installAppsFunction 'torbrowser-launcher' ;
installAppsFunction 'chromium' ;
installAppsFunction 'brave-bin' ;
installAppsFunction 'ungoogled-chromium' ;
installAppsFunction 'google-chrome' ;
installAppsFunction 'microsoft-edge-stable-bin' ;
installAppsFunction 'opera' ;
installAppsFunction 'vivaldi' ;

#terminals
clear
echo 'terminals'
sleep 3
installAppsFunction 'alacritty' ;
installAppsFunction 'xterm' ;
installAppsFunction 'kitty' ;
installAppsFunction 'deepin-terminal' ;
installAppsFunction 'rxvt-unicode' ;
installAppsFunction 'yakuake' ;
installAppsFunction 'konsole' ;

#file managers and file management tools
clear
echo "file managers and file management tools"
sleep 3
installAppsFunction 'dolphin' ;
installAppsFunction 'thunar' ;
installAppsFunction 'thunar-devel' ;
installAppsFunction 'nemo' ;
installAppsFunction 'p7zip' ;

#text editors
clear
echo "text editors"
sleep 3
installAppsFunction 'kate' ;
installAppsFunction 'atom' ;
installAppsFunction 'emacs' ;

#other important programs
clear
echo "other important programs"
sleep 3
installAppsFunction 'picom' ;
installAppsFunction 'corectrl' ;
installAppsFunction 'gwe' ;

#gaming
clear
echo "gaming"
sleep 3
installAppsFunction 'discord' ;
installAppsFunction 'steam' ;
installAppsFunction 'proton-ge-custom' ;
installAppsFunction 'wine' ;
installAppsFunction 'wine-mono' ;
installAppsFunction 'lutris' ;
installAppsFunction 'minecraft-launcher' ;
installAppsFunction 'multimc';
installAppsFunction 'prismlauncher' ;

#other
clear
echo "other"
sleep 3
installOtherAppsFunction
exit
