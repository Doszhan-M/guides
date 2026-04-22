#!/bin/bash
set -e

PROXY_URL="http://zentline_user:YOUR_PASSWORD@82.115.42.138:2128"

# Установка необходимых пакетов
sudo apt update
sudo apt -y install zsh curl git

# Установка Oh My Zsh через прокси
HTTPS_PROXY="${PROXY_URL}" HTTP_PROXY="${PROXY_URL}" \
sh -c "$(curl -x "${PROXY_URL}" -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended

# Определение переменной ZSH_CUSTOM
ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"

# Установка плагинов через прокси
HTTPS_PROXY="${PROXY_URL}" HTTP_PROXY="${PROXY_URL}" \
git clone https://github.com/zsh-users/zsh-autosuggestions "${ZSH_CUSTOM}/plugins/zsh-autosuggestions"

HTTPS_PROXY="${PROXY_URL}" HTTP_PROXY="${PROXY_URL}" \
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "${ZSH_CUSTOM}/plugins/zsh-syntax-highlighting"

# Настройка .zshrc: тема и плагины
if grep -q '^ZSH_THEME=' ~/.zshrc; then
    sed -i 's/^ZSH_THEME=".*"/ZSH_THEME="daveverwer"/' ~/.zshrc
else
    echo 'ZSH_THEME="daveverwer"' >> ~/.zshrc
fi

if grep -q '^plugins=' ~/.zshrc; then
    sed -i 's/^plugins=(.*)/plugins=(git zsh-autosuggestions zsh-syntax-highlighting)/' ~/.zshrc
else
    echo 'plugins=(git zsh-autosuggestions zsh-syntax-highlighting)' >> ~/.zshrc
fi

# Установка zsh как shell по умолчанию
chsh -s "$(which zsh)"

echo "Установка и настройка Zsh завершена успешно!"
