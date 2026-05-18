# Bluetooth на dual-boot: Windows + Ubuntu

Руководство по синхронизации Bluetooth-устройств между Windows и Ubuntu, чтобы не выполнять повторное сопряжение при переключении ОС.

---

## Проблема

При сопряжении Bluetooth-устройства каждая ОС генерирует **свой ключ шифрования** и записывает его в устройство. При переключении ОС устройство помнит только последний ключ — поэтому соединение рвётся.

**Решение:** скопировать ключ из реестра Windows в конфиг Ubuntu.

---

## Способ 1 — Через Ubuntu (рекомендуется)

### Предварительно

1. Загрузиться в **Windows** и сопрячь устройство там
2. Перезагрузиться в **Ubuntu** и сопрячь устройство заново
3. Только после этого выполнять шаги ниже

### Шаг 1 — Установить chntpw

```bash
sudo apt install chntpw
```

### Шаг 2 — Найти раздел Windows

```bash
lsblk -f
```

Найти раздел с `ntfs` без метки — это системный раздел Windows (обычно `nvme1n1p2` или `sda3`).

### Шаг 3 — Смонтировать раздел Windows

```bash
sudo mkdir /mnt/windows
sudo mount -o ro /dev/nvme1n1p2 /mnt/windows   # ← заменить на свой раздел
```

### Шаг 4 — Открыть реестр Windows

```bash
cd /mnt/windows/Windows/System32/config
sudo chntpw -e SYSTEM
```

> Сообщение `openHive failed: Read-only file system` — это нормально, chntpw всё равно читает данные.

### Шаг 5 — Найти Bluetooth-ключи

В консоли chntpw перейти к ключам:

```
cd \ControlSet001\Services\BTHPORT\Parameters\Keys
ls
```

Появится папка с MAC-адресом адаптера. Зайти в неё:

```
cd c88a9a7c2549
ls
```

Вывод покажет список устройств:
```
Node has 0 subkeys and 2 values
  size     type              value name
    16  3 REG_BINARY         <f44efd277dd5>
    16  3 REG_BINARY         <f85c7e538d79>
```

Прочитать ключ нужного устройства:

```
hex f85c7e538d79
```

Пример вывода:
```
Value <f85c7e538d79> of type REG_BINARY (3), data length 16 [0x10]
:00000  C3 12 C9 A8 64 05 69 6F 51 8D D6 3B 7E F6 D7 3C
```

Скопировать байты из строки `:00000` и выйти:

```
q
```

### Шаг 6 — Подготовить ключ

Вставить скопированные байты в команду и выполнить:

```bash
python3 << 'EOF'
key_win = "C3 12 C9 A8 64 05 69 6F 51 8D D6 3B 7E F6 D7 3C"  # ← вставить свои байты
bytes_list = key_win.strip().split()
print("Прямой:  ", "".join(bytes_list).lower())
print("Обратный:", "".join(reversed(bytes_list)).lower())
EOF
```

> Сначала попробовать **прямой** вариант. Если не заработает — использовать **обратный** (Little Endian).

### Шаг 7 — Вставить ключ в Ubuntu

```bash
sudo vim /var/lib/bluetooth/C8:8A:9A:7C:25:49/F8:5C:7E:53:8D:79/info
```

Найти секцию `[LinkKey]` и заменить значение `Key`:

```ini
[LinkKey]
Key=c312c9a8640569 6f518dd63b7ef6d73c   ← заменить на свой ключ (без пробелов, нижний регистр)
Type=4
PINLength=0
```

### Шаг 8 — Применить и проверить

```bash
sudo systemctl restart bluetooth
bluetoothctl connect F8:5C:7E:53:8D:79
```

При успехе:
```
Connection successful
```

### Шаг 9 — Настроить автоподключение

```bash
bluetoothctl trust F8:5C:7E:53:8D:79
```

Теперь достаточно включить устройство — Ubuntu подключится автоматически.

---

## Способ 2 — Через Windows

Использовать если по какой-то причине нет доступа к Ubuntu.

### Предварительно

1. Загрузиться в **Ubuntu** и сопрячь устройство там
2. Перезагрузиться в **Windows** и сопрячь устройство заново
3. Только после этого выполнять шаги ниже

### Шаг 1 — Узнать MAC-адреса устройств

В PowerShell:

```powershell
Get-PnpDevice -Class Bluetooth | Select-Object FriendlyName, InstanceId
```

MAC-адрес устройства — последние 12 символов в `InstanceId` до `_C00000000`.

Пример:
```
JBL Flip Essential 2    BTHENUM\DEV_F85C7E538D79\...
                                    ^^^^^^^^^^^^
                                    MAC устройства: F85C7E538D79
```

### Шаг 2 — Открыть реестр от имени SYSTEM

Обычный regedit не показывает Bluetooth-ключи. Нужно открыть его через PSTools.

Скачать [PSTools](https://learn.microsoft.com/en-us/sysinternals/downloads/pstools), затем в PowerShell **от администратора**:

```powershell
cd C:\путь\до\PSTools
.\psexec -s -i regedit
```

### Шаг 3 — Найти ключи Bluetooth

В редакторе реестра перейти:

```
HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\BTHPORT\Parameters\Keys\<MAC_адаптера>
```

Пример для адаптера `C8:8A:9A:7C:25:49`:
```
...\Keys\c88a9a7c2549
```

Здесь будут записи `REG_BINARY` с именами, совпадающими с MAC-адресами устройств:

| Имя ключа      | Устройство            |
|----------------|-----------------------|
| `f85c7e538d79` | JBL Flip Essential 2  |
| `f44efd277dd5` | Baseus AeQur DS10     |

Дважды кликнуть на нужном ключе и скопировать байты.

### Шаг 4 — Применить ключ в Ubuntu

Загрузиться в Ubuntu и выполнить **Шаги 6–9** из Способа 1.
