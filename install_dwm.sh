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
echo -n "Enter your username:"
read -s username
echo
echo "Adding NOPASSWD configuration for pacman and make..."
echo "$username ALL=(ALL) NOPASSWD: /usr/bin/pacman, /usr/bin/make" | sudo tee /etc/sudoers.d/$username
# Set correct permissions for the new sudoers configuration file
sudo chmod 440 /etc/sudoers.d/$username

# Install packages from the official repositories

# Read the list of packages from a text file
mapfile -t packages <official_packages

echo "Installing packages from the official repositories..."
for pkg in "${packages[@]}"; do
    echo "Installing $pkg..."
    sudo pacman -S --noconfirm --needed "$pkg"
done

# Read the list of AUR packages from a text file
mapfile -t aur_packages <aur_packages

# Install packages from the AUR
echo "Installing packages from the AUR..."
for pkg in "${aur_packages[@]}"; do
    echo "Installing $pkg..."
    yay -S --noconfirm --needed "$pkg"
done

# Clone and configure dwm
echo "Cloning dotfiles..."
git clone $dotfiles_dir
mkdir ~/dwm
cd dotfiles

# Make all files starting with #!/bin/bash executable
echo "Making scripts executable..."
find . -type f -exec grep -q -E '^#!/(bin/bash|usr/bin/env bash|bin/sh)' {} \; -exec chmod +x {} \;
# Copy files to their respective directories
echo "Copying files..."
sudo cp -r dwm/dwm_desk/* ~/dwm/
cp -r config/* ~/.config/
## Configurar geany
cp -r dwm/geany/* ~/.config/
cp -r scripts/* ~/.local/bin/

# Install dwm
echo "Installing dwm..."
cd dwm || exit
sudo -S make clean install

echo "All tasks completed successfully."

# chmod +x ~/.local/bin/*
# chmod +x ~/.config/dwm/*
# chmod +x ~/.config/dwm/rofi/**/*
# chmod +x ~/.config/dwm/config/dwm/dwm-bar_joestandring/**/*
