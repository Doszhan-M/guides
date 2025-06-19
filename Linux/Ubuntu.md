## Установка системы:
```
Во время установки выбрать минимальная установка + поддержка проприетарных драйверов
```

## Docker:
```
sudo apt-get update && sudo apt-get install -y apt-transport-https ca-certificates curl software-properties-common && curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg && echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null && sudo apt-get update && sudo apt-get install -y docker-ce docker-ce-cli containerd.io && sudo usermod -aG docker ${USER}
```

## Установка gnome-software :
```
sudo apt install gnome-software
>>>>>>> b066b4328c6ba2122757561350b816e4664fee54
```

## Установка шрифтов:
```
sudo apt install ttf-mscorefonts-installer
