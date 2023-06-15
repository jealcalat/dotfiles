#!/bin/bash

dotfiles_dir="https://github.com/jealcalat/dotfiles/"

## alternative 1: prompt the password
# # Prompt for password
# echo -n "Enter your password: "
# read -s my_pass
# echo
## All steps for installing and so should start with echo "$my pass <the rest>"

# alternative 2: no password
# Add NOPASSWD configuration for pacman and make
echo "--------------------------------------------"
echo -n "Enter your username:"
read -s username
echo
echo "Adding NOPASSWD configuration for pacman and make..."
echo "$username ALL=(ALL) NOPASSWD: /usr/bin/pacman, /usr/bin/make" | sudo tee /etc/sudoers.d/$username
# Set correct permissions for the new sudoers configuration file
sudo chmod 440 /etc/sudoers.d/$username

# Clone and configure dwm
echo "--------------------------------------------"
echo "Cloning dotfiles..."
git clone $dotfiles_dir
cd dotfiles

# Install packages from the official repositories

echo "--------------------------------------------"
echo "Installing packages from the official repositories..."
sudo pacman -S --noconfirm --needed - < official_packages

echo "--------------------------------------------"
echo "Changing default shell to zsh..."
chsh -s $(which zsh)

# Install packages from the AUR
echo "--------------------------------------------"
echo "Installing packages from the AUR..."
yay -S --noconfirm --needed - < aur_packages

# Make all files starting with #!/bin/bash executable
echo "--------------------------------------------"
echo "Replace mrrobot with its value"
find . -type f -exec sed -i -e "s@\$USER@${username}@g"  {} +;

echo "Making scripts executable..."
echo "--------------------------------------------"
find . -type f -exec grep -q -E '^#!/(bin/bash|usr/bin/env bash|bin/sh)' {} \; -exec chmod +x {} \;

# Copy files to their respective directories
echo "Copying files to dwm and .config..."
echo "--------------------------------------------"
cp -r dwm/dwm_desk/dwm ~/
cp -r config/* ~/.config/
## Configurar geany
cp -r dwm/geany ~/.config/
mkdir ~/.local/bin
cp -r scripts/* ~/.local/bin/
chmod +x ~/.local/bin/*

# Create the dwm.desktop file
echo "--------------------------------------------"
echo "Creating dwm.desktop file..."
sudo cp config/dwm/dwm.png /usr/share/icons/
cat <<EOF >dwm.desktop
[Desktop Entry]
Encoding=UTF-8
Name=DWM
Comment=Dynamic window manager
Exec=/home/mrrobot/.config/dwm/autostart.sh
Icon=/home/mrrobot/.config/dwm/dwm.png
Type=XSession
EOF
# change permisions to the icon
chmod 644 /home/mrrobot/.config/dwm/dwm.png
# Move the dwm.desktop file to the xsessions directory
sudo mv dwm.desktop /usr/share/xsessions/

# Move the zshrc file to ~/.zshrc
echo "--------------------------------------------"
echo "zsh configuration.."
echo "Moving zshrc to ~/.zshrc"
mv zsh/zshrc ~/.zshrc

echo "--------------------------------------------"
echo "Installing oh-my-zsh..."
RUNZSH=no KEEP_ZSHRC=yes sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
git clone https://github.com/zsh-users/zsh-history-substring-search ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-history-substring-search
git clone https://github.com/jirutka/zsh-shift-select.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-shift-select
starship preset pastel-powerline -o ~/.config/starship.toml

# Install dwm
echo "--------------------------------------------"
echo "Installing dwm..."
cd ~/dwm || exit
sudo -S make clean install

echo "--------------------------------------------"
echo "All tasks completed successfully."

# chmod +x ~/.local/bin/*
# chmod +x ~/.config/dwm/*
# chmod +x ~/.config/dwm/rofi/**/*
# chmod +x ~/.config/dwm/config/dwm/dwm-bar_joestandring/**/*
