## 🔧 Ubuntu 24: Как отключить встроенную камеру через udev и использовать внешнюю Logitech C920

---

### 📋 Шаг 1: Установка утилит

Убедитесь, что установлен пакет `v4l-utils`:

```bash
sudo apt update
sudo apt install v4l-utils -y
```

---

### 📋 Шаг 2: Определить устройства

Выполните:

```bash
v4l2-ctl --list-devices
```

Пример вывода:

```
HD Pro Webcam C920 (usb-0000:00:14.0-1):
	/dev/video0
	/dev/video1

USB2.0 HD UVC WebCam: USB2.0 HD (usb-0000:00:14.0-7):
	/dev/video2
	/dev/video3
```

Внешняя камера — Logitech C920.
Встроенная камера — USB2.0 HD UVC WebCam.

---

### 📋 Шаг 3: Узнать id встроенной камеры

```bash
lsusb
```

Пример вывода:

```
Bus 003 Device 004: ID 322e:202c Sonix Technology Co., Ltd. USB2.0 HD UVC WebCam
```

Значения:

* `idVendor`: `322e`
* `idProduct`: `202c`

---

### 🛠️ Шаг 4: Создать правило udev

Создайте файл правила:

```bash
sudo vim /etc/udev/rules.d/99-disable-integrated-camera.rules
```

Добавьте строку:

```bash
ACTION=="add", ATTRS{idVendor}=="322e", ATTRS{idProduct}=="202c", ATTR{authorized}="0"
```

Сохраните и закройте.

---

### 🔄 Шаг 5: Применить правила

Применить правила:

```bash
sudo udevadm control --reload
sudo udevadm trigger
sudo reboot
```

---

### ✅ Шаг 6: Проверка

После перезагрузки выполните:

```bash
v4l2-ctl --list-devices
```

Убедитесь, что отображается только **Logitech C920**, а встроенная камера исчезла из списка.

---

### ♻️ Как включить встроенную камеру обратно

Удалите созданное правило:

```bash
sudo rm /etc/udev/rules.d/99-disable-integrated-camera.rules
sudo udevadm control --reload
sudo udevadm trigger
sudo reboot
```

---

Готово ✅
Теперь сайт или приложение будет использовать только внешнюю камеру.
