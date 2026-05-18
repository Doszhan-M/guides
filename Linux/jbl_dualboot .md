# Bluetooth на dual-boot: Windows + Ubuntu

Руководство по синхронизации Bluetooth-устройств между Windows и Ubuntu, чтобы не выполнять повторное сопряжение при переключении ОС.

---

## Проблема

При сопряжении Bluetooth-устройства каждая ОС генерирует **свой ключ шифрования** и записывает его в устройство. При переключении ОС устройство помнит только последний ключ — поэтому соединение рвётся.

**Решение:** скопировать ключ из реестра Windows в конфиг Ubuntu.

---

## Шаг 1 — Собрать данные в Windows

### 1.1 Узнать MAC-адрес адаптера и устройств

Открыть PowerShell и выполнить:

```powershell
Get-PnpDevice -Class Bluetooth | Select-Object FriendlyName, InstanceId
```

В выводе найти строки вида:
```
JBL Flip Essential 2    BTHENUM\DEV_F85C7E538D79\...
```

MAC-адрес устройства — последние 12 символов до `_C00000000` → `F85C7E538D79`

### 1.2 Открыть реестр от имени SYSTEM

Скачать [PSTools](https://learn.microsoft.com/en-us/sysinternals/downloads/pstools), затем в PowerShell (от администратора):

```powershell
cd C:\путь\до\PSTools
.\psexec -s -i regedit
```

### 1.3 Найти ключи Bluetooth

В редакторе реестра перейти по пути:

```
HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\BTHPORT\Parameters\Keys\<MAC_адаптера>
```

Пример пути для адаптера `C8:8A:9A:7C:25:49`:
```
...\Keys\c88a9a7c2549
```

Здесь будут записи вида `REG_BINARY` с именами, совпадающими с MAC-адресами устройств:

| Имя ключа      | Устройство         |
|----------------|--------------------|
| `f85c7e538d79` | JBL Flip Essential 2 |
| `f44efd277dd5` | Baseus AeQur DS10  |

Значение — 16 байт, например:
```
c3 12 c9 a8 64 05 69 6f 51 8d d6 3b 7e f6 d7 3c
```

---

## Шаг 2 — Подготовить ключ

Скопировать байты из реестра и выполнить в Ubuntu:

```bash
python3 << 'EOF'
key_win = "c3 12 c9 a8 64 05 69 6f 51 8d d6 3b 7e f6 d7 3c"  # ← вставить свои байты
bytes_list = key_win.strip().split()
print("Прямой:  ", "".join(bytes_list))
print("Обратный:", "".join(reversed(bytes_list)))
EOF
```

> **Примечание:** Windows иногда хранит ключ в формате Little Endian (обратный порядок байт).
> Сначала попробовать **прямой** вариант. Если не заработает — использовать **обратный**.

---

## Шаг 3 — Сопрячь устройство в Ubuntu

Перед редактированием конфига устройство должно быть сопряжено в Ubuntu:

```bash
bluetoothctl
scan on
# дождаться появления устройства
pair F8:5C:7E:53:8D:79
connect F8:5C:7E:53:8D:79
exit
```

---

## Шаг 4 — Вставить ключ в Ubuntu

Открыть файл настроек устройства:

```bash
sudo nano /var/lib/bluetooth/<MAC_адаптера>/<MAC_устройства>/info
```

Пример:
```bash
sudo nano /var/lib/bluetooth/C8:8A:9A:7C:25:49/F8:5C:7E:53:8D:79/info
```

Найти секцию `[LinkKey]` и заменить значение `Key`:

```ini
[LinkKey]
Key=c312c9a8640569 6f518dd63b7ef6d73c   ← заменить на свой ключ (без пробелов, нижний регистр)
Type=4
PINLength=0
```

---

## Шаг 5 — Применить изменения

```bash
sudo systemctl restart bluetooth
bluetoothctl connect F8:5C:7E:53:8D:79
```

При успехе будет выведено:
```
Connection successful
```

---

## Шаг 6 — Настроить автоподключение

```bash
bluetoothctl trust F8:5C:7E:53:8D:79
```

После этого Ubuntu будет автоматически подключаться к устройству при его включении.
| Файл `info` не найден | Убедиться что устройство сначала сопряжено в Ubuntu |
| `bluetoothctl connect` зависает | Выключить и включить колонку, повторить |
| После перезагрузки не подключается | Проверить что выполнен `bluetoothctl trust` |
