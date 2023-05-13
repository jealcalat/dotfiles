
Dotfiles for newdwm installation (based on archcraft-dwm)

# instrucciones

## Install dwm y st de novo (o pasar a la siguiente)

`git clone https://git.suckless.org/dwm`

`git clone https://git.suckless.org/st`

`cd dwm`

`sudo make clean install`

`cd ../st`

`sudo make clean install`

## Reemplazar dwm config files por las propias:

```console
git clone https://github.com/jealcalat/dotfiles/
cd dotfiles
sudo cp -r dwm/dwm_lap/* ~/dwm/
cp -r config/* ~/.config/
## Configurar geany
cp -r dwm/geany/* ~/.config/
cp -r scripts/* ~/.local/bin/
chmod +x ~/.local/bin/*
chmod +x ~/.config/dwm/*
chmod +x ~/.config/dwm/rofi/**/*
chmod +x ~/.config/dwm/config/dwm/dwm-bar_joestandring/**/*
cd dwm
sudo make clean install
```

<!-- ## Crear directorio .config/dwm y colocar lo  s archivos de la carpeta dwm

```console
cd ..
cp -r dwm/ .config/dwm
``` -->

## Instalar dependencias (algunas con yay)

```console
sudo pacman -Syu \
--needed --noconfirm \
base-devel libx11 libxft libxinerama freetype2 rofi polybar geany dunst dmenu meld baobab catfish v4l-utils alacritty firefox ranger ibus xorg-xsetroot sxhkd xorg-xbaclight fontconfig
```

```console
sudo pacman -S xorg-xsetroot
```

En Yay

```console
yay -S maim xclip ksuperkey betterlockscreen hsetroot 
```

## Instalar paquetes adicionales

Para R, LaTeX, etc
```console
sudo pacman -Syu tk r gcc-fortran texlive-most pandoc
```

```
yay -S -y --noconfirm quarto-cli rstudio-desktop-bin openblas-lapack visual-studio-code-bin nerd-fonts-meta
```

Para R en vscode (R, jupyter nb, plots, etc)

```console
pip3 install -U radian
```

En R:

```r
install.packages(c('IRkernel','languageserver', 'httpgd'))
IRkernel::installspec()
```
## Crear DWM.desktop

```
[Desktop Entry]
Encoding=UTF-8
Name=DWM
Comment=Dynamic window manager
Exec=/home/$USER/.config/dwm/autostart.sh
Icon=dwm
Type=XSession
```

## Instalar oh-my-zsh

```console
sudo pacman -Syu zsh
```

```console
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
```

**Instalar zsh-autosuggestions**

```console
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
```

**Instalar syntax highligting**

```console
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
```

**zsh-history-substring-search**

```console
 git clone https://github.com/zsh-users/zsh-history-substring-search ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-history-substring-search
```

**zsh-completions**

```console
  git clone https://github.com/zsh-users/zsh-completions ${ZSH_CUSTOM:-${ZSH:-~/.oh-my-zsh}/custom}/plugins/zsh-completions
``` 

## Instalar starship

```console
curl -sS https://starship.rs/install.sh | sh
```

Usar un preset de starship

```console
starship preset pastel-powerline -o ~/.config/starship.toml
```

## TODO:

1. Revisar el script que [estaba haciendo](https://github.com/jealcalat/dots_newdwm/blob/main/install_custom_dwm) basado en el de [LUKE SMITH](https://github.com/LukeSmithxyz/LARBS).
2. Probarlo en VMS