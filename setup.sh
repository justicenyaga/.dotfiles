#### DONT RUN AS ROOT ####

if [ "$(id -u)" = 0 ]; then
    echo "This script MUST NOT be run as root" 1>&2
    exit 1
fi


#### UPGRADING SYSTEM ####

printf "\nUpgrading system\n"
sleep 1

sudo pacman -Syu --noconfirm


#### INSTALL YAY ####

printf "\nInstalling yay...\n"
sleep 1

sudo pacman -S base-devel git --needed --noconfirm
git clone https://aur.archlinux.org/yay.git
cd yay
makepkg -si


#### INSTALL PACKAGES ####

printf "\nInstalling packages\n"
sleep 1


packages="apple_cursor base bat blueman brave-bin brightnessctl chili-sddm-theme emote eza fd feh file-roller fzf 
  git-credential-manager-bin git-delta gnome-keyring grim gvfs gvfs-mtp htop hyprland hyprlock hyprpaper i3-wm
  imagemagick keyd kitty kvantum lazygit man-db mercurial mpd mpc mpv neovim net-tools ntfs-3g nwg-look
  obsidian pass picom polybar power-profiles-daemon python-pipenv python-pipx python-pynvim qt6ct ripgrep rofi
  seahorse shotwell stow thunar thunar-volman timidity++ tmux ttf-cascadia-code ttf-fira-sans
  ttf-jetbrains-mono-nerd ttf-joypixels ttf-meslo-nerd ttf-nerd-fonts-symbols-mono ttf-roboto ttf-terminus-nerd
  unzip waybar wget wlogout wl-clipboard wofi xclip xdg-user-dirs xfce4-notifyd xfce-polkit xorg-font-util
  xorg-fonts-misc xorg-mkfontscale yazi zip zoxide zsh"

yay -Sy $packages --needed --noconfirm

# install autotiling
pipx install autotiling

#### PREPARING FOLDERS ####

if [[ ! -e "$HOME/.config/user-dirs.dirs" ]]; then
  xdg-user-dirs-update
fi
mkdir ~/.mpd/playlists -p

#### INSTALL RICE ####

printf "\nInstalling dotfiles\n"
sleep 1

# install root target packages
sudo stow --adopt -t / root

# install home target packages
stow --adopt -t ~/ home

printf "\nBuilding bat theme\n"
sleep 1

bat cache --build 
