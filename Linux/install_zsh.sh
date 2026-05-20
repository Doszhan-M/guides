#!/usr/bin/env bash
set -euo pipefail

sudo apt-get update
sudo apt-get install -y zsh curl git

if [ ! -d "$HOME/.oh-my-zsh" ]; then
  RUNZSH=no CHSH=no sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
fi

ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"

if [ ! -d "$ZSH_CUSTOM/plugins/zsh-autosuggestions" ]; then
  git clone https://github.com/zsh-users/zsh-autosuggestions "$ZSH_CUSTOM/plugins/zsh-autosuggestions"
fi

if [ ! -d "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting" ]; then
  git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting"
fi

if grep -q '^ZSH_THEME=' "$HOME/.zshrc"; then
  sed -i 's/^ZSH_THEME=.*/ZSH_THEME="daveverwer"/' "$HOME/.zshrc"
else
  echo 'ZSH_THEME="daveverwer"' >> "$HOME/.zshrc"
fi

if grep -q '^plugins=' "$HOME/.zshrc"; then
  sed -i 's/^plugins=.*/plugins=(git zsh-autosuggestions zsh-syntax-highlighting)/' "$HOME/.zshrc"
else
  echo 'plugins=(git zsh-autosuggestions zsh-syntax-highlighting)' >> "$HOME/.zshrc"
fi

sudo chsh -s "$(command -v zsh)" "$USER"

echo "Zsh configured. Re-login to apply shell change."
