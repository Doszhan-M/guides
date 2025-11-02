## Установка системы

```
Во время установки выбрать минимальная установка + поддержка проприетарных драйверов
```

---

## Docker

```
sudo apt-get update && sudo apt-get install -y apt-transport-https ca-certificates curl software-properties-common && curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg && echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null && sudo apt-get update && sudo apt-get install -y docker-ce docker-ce-cli containerd.io && sudo usermod -aG docker ${USER}
```

---

## Установка gnome-software

```
sudo apt install gnome-software
```

---

## Установка шрифтов

```
sudo apt install ttf-mscorefonts-installer
```

---

## Ускорение скрола imwheel

### Установка

```bash
sudo apt install imwheel
```

### Настройка

Скопируйте содержимое подготовленного файла `imwheelrc` в:

```bash
vim ~/.imwheelrc
```

### Запуск

```bash
imwheel -b "4 5"
```

### Перезапуск

```bash
killall imwheel 2>/dev/null; imwheel -b "4 5"
```

### Автозапуск при входе

```bash
mkdir -p ~/.config/autostart
cat > ~/.config/autostart/imwheel.desktop <<'EOF'
[Desktop Entry]
Type=Application
Name=imwheel
Exec=imwheel -b "4 5"
X-GNOME-Autostart-enabled=true
EOF
```

### Определение имени окна
```
xprop | grep -i 'wm_class\|wm_name'
```
---
