## Если не настроен apt после установки
```
su -
nano /etc/apt/sources.list
--------------------------------------------------------------------------------------
deb http://httpredir.debian.org/debian bookworm main non-free-firmware
deb-src http://httpredir.debian.org/debian bookworm main non-free-firmware

deb http://security.debian.org/debian-security bookworm-security main non-free-firmware
deb-src http://security.debian.org/debian-security bookworm-security main non-free-firmware

deb http://httpredir.debian.org/debian bookworm-updates main non-free-firmware
deb-src http://httpredir.debian.org/debian bookworm-updates main non-free-firmware
--------------------------------------------------------------------------------------

nano /etc/resolv.conf 
--------------------------------------------------------------------------------------
nameserver 8.8.8.8
nameserver 8.8.4.4
--------------------------------------------------------------------------------------

apt update && apt install sudo && usermod -aG sudo pk-dev && reboot
sudo visudo
F1rstB1t
pk-dev ALL=(ALL) NOPASSWD:ALL
sudo apt update && sudo apt upgrade -y && sudo reboot
```



## flathub install
```
https://flatpak.org/setup/Debian
sudo apt install flatpak
sudo apt install gnome-software-plugin-flatpak
sudo flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
sudo reboot

flatpak search chrome
flatpak install flathub com.google.Chrome 
flatpak install org.telegram.desktop 
```

## Установка расширении:
```
Из менеджера приложении установить Extension Manager

Dash To Panel
AppIndicator and KStatusNotifierItem
Clipboard Indicator
Clipboard History (не совместим с ubuntu)
Burn my Windows
Compiz Windows Effect
```

## Переключение раскладки клавиатуры:
```
gsettings set org.gnome.desktop.wm.keybindings switch-input-source "['<Shift>Alt_L']"
gsettings set org.gnome.desktop.wm.keybindings switch-input-source-backward "['<Alt>Shift_L']"
```

## Шорткат для терминала:
```
terminal
gnome-terminal
super + T
```

## crow-translate:
```
можно установить из flathub через магазин
```

## Docker:
```
sudo apt update && sudo apt upgrade -y && sudo apt install apt-transport-https ca-certificates curl software-properties-common gnupg -y && curl -fsSL https://download.docker.com/linux/debian/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg && echo "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/debian $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list  /dev/null && apt-cache policy docker-ce && sudo apt update && sudo apt install docker-ce -y && sudo systemctl start docker && sudo systemctl enable docker && sudo usermod -aG docker ${USER} && sudo su - ${USER} && id -nG && docker --version
```

## zsh:
```
sudo apt -y install zsh vim
zsh
sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
git clone https://github.com/zsh-users/zsh-autosuggestions ~/.oh-my-zsh/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git $ZSH_CUSTOM/plugins/zsh-syntax-highlighting
vim ~/.zshrc 
ZSH_THEME="philips"
plugins=(git zsh-autosuggestions zsh-syntax-highlighting)
reboot pc

Статьи:
  https://habr.com/ru/post/516004/
по умолчанию:
  https://losst.ru/nastrojka-zsh-i-oh-my-zsh
темы отредактировать vi ~/.zshrc:
  https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
Автодополнение:
  https://tehnojam.ru/category/software/oh-my-zsh-autocomlite-like-fish.html

Можно установить через готовый скрипт:
vim install_zsh.sh
chmod +x install_zsh.sh
./install_zsh.sh
sudo reboot  # необязательно, переподключиться
```

## Install solaar:
```
sudo apt update
sudo apt -y install solaar
Если подсветка клавиатуры не включается:
sudo /etc/acpi/asus-keyboard-backlight.sh
```

## Изменить локаль на ru:
```
https://unix.stackexchange.com/questions/679315/gnome-debian-11-how-to-install-en-dk-formats-date-numbers-units
  sudo vim /etc/locale.gen
uncomment: ru_RU.UTF-8 UTF-8
  sudo locale-gen
  изменить локали в настройках
```

## openssh-server:
```
sudo apt install openssh-server -y
sudo systemctl enable ssh
sudo service ssh status 
sudo vi /etc/ssh/sshd_config
port 23
sudo systemctl restart ssh
Если надо отключить:
sudo systemctl disable ssh
```

## grub-settings:
```
sudo apt update
sudo apt install grub-customizer -y
sudo grub-customizer

Если не удалось найти в apt, то добавить репозиторий:
sudo add-apt-repository ppa:danielrichter2007/grub-customizer 
sudo apt update 
sudo apt install grub-customizer -y
Потом удалить репозитории:
sudo add-apt-repository --remove ppa:danielrichter2007/grub-customizer

command for install custom theme:
cd ~/Programs
git clone https://github.com/vinceliuice/grub2-themes.git
GRUB_SAVEDEFAULT=true
sudo ./install.sh -t whitesur -s 2k
sudo update-grub

если grub не сохраняет последнею загрузку:
sudo vim  /etc/default/grub 
добавить:
GRUB_DEFAULT="saved"
GRUB_SAVEDEFAULT=true 
sudo update-grub  
GRUB_DISABLE_OS_PROBER=false
  
sudo update-grub
```

## Удалить ненужные программы:
```
sudo apt purge gnome-2048 fcitx kasumi aisleriot atomix gnome-chess five-or-more hitori iagno gnome-klotski lightsoff gnome-mahjongg gnome-mines gnome-nibbles quadrapassel four-in-a-row gnome-robots gnome-sudoku swell-foop tali gnome-taquin gnome-tetravex -y & sudo apt autoremove -y
sudo apt purge xiterm+thai goldendict gnome-contacts gnome-documents hdate-applet uim-gtk2.0 mozc-server mozc-utils-gui mozc-data mlterm malcontent shotwell thunderbird
sudo apt -y purge mlterm-im-skk mlterm-im-uim mlterm-im-wnn mlterm-tiny mlterm-im-canna mlterm-im-scim mlterm-im-m17nlib mlterm-tools mlterm mlterm-im-ibus mlterm-common mlterm-im-fcitx
```

## Install NVIDIA 
```
https://fostips.com/install-nvidia-driver-debian-12/
sudo apt install -y inxi neofetch htop git
neofetch
inxi -G
inxi -A
```

## Символьная ссылка на папку в другом диске:
```
в утилите disks задать auto mount для диска
sudo ln -s /mnt/E2666DE8666DBE43/Store /home/asus/Store
```

## Изменить фон загрузки
создать banner.png
sudo cp banner.png /usr/share/images/desktop-base/
sudo vim /etc/default/grub:
-------------------------------------------------------------
GRUB_BACKGROUND="/usr/share/images/desktop-base/banner.png"
-------------------------------------------------------------

## Ограничение заряда батареи на 90%
```
sudo apt update  
sudo apt install tlp tlp-rdw -y
sudo vim /etc/tlp.conf  
-------------------------------------------------------------
START_CHARGE_THRESH_BAT0=75
STOP_CHARGE_THRESH_BAT0=90
-------------------------------------------------------------
sudo tlp start
sudo tlp-stat
```

## Изменить яркость экрана:
```
Найти экран:
  xrandr -q 
  "DP-1"
От 0 до 1:
  xrandr --output DP-1 --brightness 0.4 
```


# Чтобы для пользователя не запрашивался пароль надо добавить после # Allow members of group sudo to execute any command в конец
```
sudo visudo
username ALL=(ALL) NOPASSWD:ALL
```
