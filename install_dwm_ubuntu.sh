#!/bin/bash

# Functions
install_packages() {
    sudo apt install -y "$@"
}

clone_and_cd() {
    git clone "$1" && cd "${1##*/}" || exit
    print_current_dir
}

print_current_dir() {
    echo "----------------------------------------------"
    echo "---current directory is $(pwd) ---"
    echo "----------------------------------------------"
}

# Variables
dotfiles_dir="https://github.com/jealcalat/dotfiles/"
user_home="/home/mrrobot"
cd $user_home/Downloads
echo "This script will install dwm build for Ubuntu."
sleep 2s

echo "----------------------------------------------"
echo "Updating ubuntu...\n"
sudo apt update && sudo apt upgrade

echo "----------------------------------------------"
echo "Adding alacritty repository...\n"
sleep 2s
sudo add-apt-repository ppa:aslatter/ppa -y && sudo apt update

echo "----------------------------------------------"
echo "Installing common packages...\n"
sleep 2s
# Install common packages
install_packages curl alacritty arandr git gnome-disk-utility gpick brightnessctl btop catfish suckless-tools dunst file-roller ffmpeg ffmpegthumbnailer firefox flameshot fontconfig libfreetype6-dev galculator gfortran geany gthumb gnome-keyring ibus inkscape libreoffice libx11-dev libxft2 libxinerama-dev meld mlocate meson neofetch network-manager fonts-noto-color-emoji ntfs-3g pandoc playerctl python3-pip qtbase5-dev qtdeclarative5-dev libqt5svg5 r-base ranger rofi slop sxhkd texlive-full thunar thunar-archive-plugin tcl tk fonts-dejavu fonts-font-awesome unzip maim xclip hsetroot nautilus-dropbox xfonts-terminus zsh

install_packages libx11-dev libgl1-mesa-dev libpcre2-dev libconfig-dev libxdg-basedir-dev libpixman-1-dev uthash-dev libxft-dev
install_packages autoconf gcc make pkg-config libpam0g-dev libcairo2-dev libfontconfig1-dev libxcb-composite0-dev libev-dev libx11-xcb-dev libxcb-xkb-dev libxcb-xinerama0-dev libxcb-randr0-dev libxcb-image0-dev libxcb-util-dev libxcb-xrm-dev libxkbcommon-dev libxkbcommon-x11-dev libjpeg-dev

# zsh configuration
echo "----------------------------------------------"
printf "Changing default shell to zsh and configuring...\n"
sleep 1s
chsh -s $(which zsh)
RUNZSH=no KEEP_ZSHRC=yes sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-$user_home/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-$user_home/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
git clone https://github.com/zsh-users/zsh-history-substring-search ${ZSH_CUSTOM:-$user_home/.oh-my-zsh/custom}/plugins/zsh-history-substring-search
git clone https://github.com/jirutka/zsh-shift-select.git ${ZSH_CUSTOM:-$user_home/.oh-my-zsh/custom}/plugins/zsh-shift-select
mv zsh/zshrc $user_home/.zshrc
# install starship
curl -sS https://starship.rs/install.sh | sh
starship preset pastel-powerline -o $user_home/.config/starship.toml

# Clone and configure dwm
echo "----------------------------------------------"
printf "Cloning dotfiles from github...\n"
sleep 1s
clone_and_cd $dotfiles_dir

# Make all files starting with #!/bin/bash executable
echo "--------------------------------------------"
echo "Making scripts executable...\n"
sleep 2s
find . -type f -exec grep -q -E '^#!/(bin/bash|usr/bin/env bash|bin/sh)' {} \; -exec chmod +x {} \;

# Install and configure dwm
echo "--------------------------------------------"
echo "Installing and configuring dwm...\n"
cd dotfiles
cp -r dwm/dwm_desk/dwm $user_home/
cp -r config/* $user_home/.config/
mkdir $user_home/.local/bin
cp -r scripts/* $user_home/.local/bin/
chmod +x $user_home/.local/bin/*
chmod +x $user_home/.config/dwm/autostart.sh

# Create and move dwm.desktop file
echo "--------------------------------------------"
printf "Creating and moving dwm.desktop file...\n"
sudo cp config/dwm/dwm.png /usr/share/icons/
cat <<EOF >dwm.desktop
[Desktop Entry]
Encoding=UTF-8
Name=DWM
Comment=Dynamic window manager
Exec=$user_home/.config/dwm/autostart.sh
Icon=dwm
Type=XSession
EOF
sudo mv dwm.desktop /usr/share/xsessions/

# Finalize installation
echo "--------------------------------------------"
printf "Install custom dwm build...\n"
cd $user_home/dwm || exit
sudo -S make clean install

cd $user_home/Downloads
# betterlockscreen
echo "--------------------------------------------"
printf "Configuring betterlockscreen...\n"
clone_and_cd https://github.com/Raymo111/i3lock-color
./install-i3lock-color.sh
cd $user_home/Downloads
wget https://github.com/betterlockscreen/betterlockscreen/archive/refs/heads/main.zip
unzip main.zip && cd betterlockscreen-main/
chmod u+x betterlockscreen
sudo cp betterlockscreen /usr/local/bin/
sudo cp system/betterlockscreen@.service /usr/lib/systemd/system/
sudo systemctl enable betterlockscreen@$USER
cd $user_home/Downloads

# ksuperkey
echo "--------------------------------------------"
echo "Installing ksuperkey...\n"
install_packages gcc make libxtst-dev pkg-config
clone_and_cd https://github.com/hanschen/ksuperkey
make && sudo make install
cd $user_home/Downloads

# picom experimental
echo "--------------------------------------------"
echo "Installing picom...\n"
install_packages libxcb-render-util0-dev libxext-dev libxcb1-dev libxcb-damage0-dev libxcb-xfixes0-dev libxcb-shape0-dev libxcb-render-util0-dev libxcb-render0-dev libxcb-randr0-dev libxcb-composite0-dev libxcb-image0-dev libxcb-present-dev libxcb-xinerama0-dev libxcb-glx0-dev libpixman-1-dev libdbus-1-dev libconfig-dev libgl1-mesa-dev libpcre2-dev libevdev-dev uthash-dev libev-dev libx11-xcb-dev
clone_and_cd https://github.com/jonaburg/picom
meson --buildtype=release . build
ninja -C build
sudo ninja -C build install
cd $user_home/Downloads

echo "-------------------------------------------"
printf "Installing nerd fonts...\n"
clone_and_cd https://github.com/ryanoasis/nerd-fonts
chmod +x install.sh
./install.sh
cd $user_home/Downloads

echo "--------------------------------------------"
printf "Installing spotify...\n"
curl -sS https://download.spotify.com/debian/pubkey_7A3A762FAFD4A51F.gpg | sudo gpg --dearmor --yes -o /etc/apt/trusted.gpg.d/spotify.gpg
echo "deb http://repository.spotify.com stable non-free" | sudo tee /etc/apt/sources.list.d/spotify.list
sudo apt-get update && sudo apt-get install spotify-client

echo "--------------------------------------------"
printf "Installing VScode...\n"
sudo apt install software-properties-common apt-transport-https wget -y
wget -q https://packages.microsoft.com/keys/microsoft.asc -O- | sudo apt-key add -
sudo add-apt-repository "deb [arch=amd64] https://packages.microsoft.com/repos/vscode stable main"
sudo apt install code


printf "\n--------------------------------------------\n"
printf "All tasks completed successfully.\n"
echo "Enjoy Ububtu-DWM."

