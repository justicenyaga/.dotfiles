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


packages="ags-hyprpanel-git apple_cursor base bat blueman brave-bin brightnessctl btop chili-sddm-theme clang cliphist cmake 
  conceal-bin dragon-drop emote eza falkon fd feh ffmpegthumbnailer file-roller fzf git-credential-manager-bin git-delta glow 
  gnome-keyring gnome-system-monitor google-chrome grim gvfs gvfs-mtp htop hyprland hyprlock hyprpaper hyprshot-git i3-wm 
  imagemagick jq keyd kitty kvantum lazygit libxml2-legacy man-db mediainfo mercurial mpd mpc mpv neofetch neovim 
  net-tools noto-fonts noto-fonts-emoji ntfs-3g nvm nwg-look nvim-treesitter-parsers-git obsidian outlook-for-linux-bin
  p7zip pass perl-image-exiftool picom polybar poppler postman power-profiles-daemon pyenv python-pipenv python-pipx 
  python-pynvim qt6ct ripgrep rofi seahorse shotwell stow teams-for-linux-bin thunar thunar-volman timidity++ timeshift 
  timeshift-autosnap tmux ttf-cascadia-code ttf-fira-sans ttf-jetbrains-mono-nerd ttf-joypixels ttf-meslo-nerd 
  ttf-nerd-fonts-symbols-mono ttf-roboto ttf-terminus-nerd unrar unzip waybar wezterm wget wlogout wl-clipboard wofi xclip 
  xdg-user-dirs xfce4-notifyd xfce-polkit xorg-font-util xorg-fonts-misc xorg-mkfontscale xorg-xhost yazi zen-browser-bin zip 
  zoxide zsh"

yay -Sy $packages --needed --noconfirm

# install autotiling
pipx install autotiling subliminal

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

printf "\nInstalling yazi's catppuccin-mocha flavor\n"
sleep 1

ya pkg add yazi-rs/flavors:catppuccin-mocha
