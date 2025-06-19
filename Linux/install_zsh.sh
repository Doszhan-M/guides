#!/bin/bash

# Установка необходимых пакетов
sudo apt update
sudo apt -y install zsh curl git

# Установка Oh My Zsh
sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended

# Определение переменной ZSH_CUSTOM
ZSH_CUSTOM=${ZSH_CUSTOM:-~/.oh-my-zsh/custom}

# Установка плагинов zsh-autosuggestions и zsh-syntax-highlighting
git clone https://github.com/zsh-users/zsh-autosuggestions $ZSH_CUSTOM/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git $ZSH_CUSTOM/plugins/zsh-syntax-highlighting

# Настройка .zshrc: добавление темы и плагинов
if grep -q "ZSH_THEME=" ~/.zshrc; then
    sed -i 's/^ZSH_THEME=".*"/ZSH_THEME="daveverwer"/' ~/.zshrc
else
    echo 'ZSH_THEME="philips"' >> ~/.zshrc
fi

if grep -q "plugins=(" ~/.zshrc; then
    sed -i 's/^plugins=(.*)/plugins=(git zsh-autosuggestions zsh-syntax-highlighting)/' ~/.zshrc
else
    echo 'plugins=(git zsh-autosuggestions zsh-syntax-highlighting)' >> ~/.zshrc
fi

sudo chsh -s $(which zsh) $USER

echo "Установка и настройка Zsh завершена успешно!"
