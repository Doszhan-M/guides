## Установка системы

```
Во время установки выбрать минимальная установка + поддержка проприетарных драйверов
```
---

## Установить apt mirror на Neolabs
```
sudo tee /etc/apt/sources.list.d/ubuntu.sources > /dev/null <<'EOF'
Types: deb
URIs: https://mirror.neolabs.kz/ubuntu/
Suites: noble noble-updates noble-backports noble-security
Components: main restricted universe multiverse
Signed-By: /usr/share/keyrings/ubuntu-archive-keyring.gpg
EOF
sudo apt update
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

### Если не работает, то надо перейти на X11
```
echo $XDG_SESSION_TYPE
```
---


# Быстрое решение задержки 60 секунд при запуске Ubuntu 24

Эта проблема часто возникает в Ubuntu 23.10 / 24.04: интернет появляется только через минуту после загрузки, GNOME Terminal долго не открывается, приложения (Telegram, VSCode, Chrome) зависают.

Главная причина — сломанный **xdg-desktop-portal-gnome**, который конфликтует со Snap-версиями GNOME.

## 🔍 Проверка

Проверь какие Snap GNOME runtime установлены:

```bash
snap list | grep gnome
```

Если есть `gnome-3-*`, `gnome-42-*`, `gnome-46-*` → они конфликтуют.

---

## ✅ Решение

### 1) Удалить конфликтующие Snap GNOME runtime

```bash
sudo snap remove gnome-3-28-1804
sudo snap remove gnome-42-2204
sudo snap remove gnome-46-2404
```

*(версии в твоей системе могут отличаться — смотри через `snap list | grep gnome`)*

### 2) Переустановить системные порталы

```bash
sudo apt remove xdg-desktop-portal-gnome
sudo apt install --reinstall xdg-desktop-portal xdg-desktop-portal-gtk
```

### 3) Очистить кэш порталов

```bash
rm -rf ~/.cache/xdg-desktop-portal
rm -rf ~/.local/share/xdg-desktop-portal
```

### 4) Перезагрузка

```bash
reboot
```

---
