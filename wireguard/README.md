# wireguard

```
1. Заполнить ip адрес от vps
2. docker-compose up 
3. scp -r root@server_ip_address:config_path/config_folder ./
4. Скачать клиент wireguard https://www.wireguard.com/install/
5. Запустить клиент через конфиг
5. Можно удалить все файлы кроме conf_name.conf
```

## Клиент для Linux
sudo apt install wireguard -y
```
1. Переместить конфиг файл peer_myPCLin.conf в /etc/wireguard:
2. Проверить работоспособность(без расширения конфига): 
   sudo wg-quick up peer_myPCLin
   
Если нужен автозапуск:
1. Создать systemd задачу: 
sudo systemctl enable wg-quick@peer_myPCLin.service
2. Запустить: 
sudo systemctl start wg-quick@peer_myPCLin.service
3. Проверить: 
sudo systemctl status wg-quick@peer_myPCLin.service 

Отключение автозапуска: 
sudo systemctl disable wg-quick@peer_myPCLin.service  
```
