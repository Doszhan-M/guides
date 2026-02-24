# Ubuntu 24: ZRAM + swapfile (чтобы убрать фризы при нехватке RAM)


---

## 0) Диагностика (перед настройкой)

Проверить, есть ли swap и сколько памяти свободно:

```bash
swapon --show
free -h
cat /proc/swaps
```

Если `Swap: 0B` и `swapon --show` пустой — swap отключён.

---

## 1) Проверка: есть ли готовый swap-раздел (swap partition)

```bash
lsblk -o NAME,SIZE,TYPE,FSTYPE,MOUNTPOINTS,UUID
blkid | grep -i swap
```

* Если видишь раздел с `FSTYPE=swap` — можно включить его:

```bash
sudo swapon /dev/<swap-partition>
swapon --show
```

* Если раздела нет (как в нашем случае) — делаем ZRAM + swapfile.

---

## 2) Включить ZRAM (быстрый swap в RAM с сжатием)

### 2.1 Установить генератор

```bash
sudo apt update
sudo apt install -y systemd-zram-generator
```

### 2.2 Создать конфиг ZRAM

```bash
sudo tee /etc/systemd/zram-generator.conf >/dev/null <<'EOF'
[zram0]
zram-size = ram / 2
compression-algorithm = zstd
swap-priority = 100
EOF
```

### 2.3 Применить

```bash
sudo systemctl daemon-reload
sudo systemctl restart systemd-zram-setup@zram0.service
```
### 2.4 Перезагрузить систему

```bash
sudo reboot
```
### 2.4 Проверить

```bash
swapon --show
```

Ожидаемый результат: появится `/dev/zram0` (примерно `ram/2`) с `PRIO 100`.

---

## 3) Настроить swappiness (чтобы система не начинала “жевать” диск слишком рано)

```bash
echo 'vm.swappiness=20' | sudo tee /etc/sysctl.d/99-swappiness.conf
sudo sysctl -p /etc/sysctl.d/99-swappiness.conf
sysctl vm.swappiness
```

Ожидаемо: `vm.swappiness = 20`.

---

## 4) Добавить swapfile на диске (второй уровень, страховка)

> ZRAM быстрый, но если RAM реально заканчивается, swapfile помогает избежать фризов/убийства процессов.

### 4.1 Создать swapfile (пример: 8GB)

```bash
sudo fallocate -l 8G /swapfile
sudo chmod 600 /swapfile
sudo mkswap /swapfile
sudo swapon /swapfile
```

### 4.2 Задать приоритет swapfile (чтобы он был вторым после ZRAM)

```bash
sudo swapoff /swapfile
sudo swapon -p 10 /swapfile
swapon --show
```

Ожидаемо:

* `/dev/zram0` — `PRIO 100`
* `/swapfile` — `PRIO 10`

### 4.3 Автоподключение swapfile после перезагрузки

```bash
echo '/swapfile none swap sw,pri=10 0 0' | sudo tee -a /etc/fstab
```

Проверить, что строка одна:

```bash
grep -n '/swapfile' /etc/fstab
```

---

## 5) Быстрая проверка “как будет после ребута” (без ребута)

```bash
sudo swapoff -a
sudo swapon -a
swapon --show
free -h
```

---

## 6) Проверка логов на OOM (если фризы были раньше)

Текущий бут:

```bash
journalctl -k -b | grep -Ei 'oom|out of memory|killed process|systemd-oomd' | tail -80
```

Предыдущий бут:

```bash
journalctl -k -b -1 | grep -Ei 'oom|out of memory|killed process|systemd-oomd' | tail -80
```

---

## Итоговая цель

После всех шагов команда должна показывать примерно так:

```bash
swapon --show
```

* `/dev/zram0` (примерно половина RAM), `PRIO 100`
* `/swapfile` (например 8GB), `PRIO 10`

---

## Рекомендуемые размеры

* **ZRAM:** `ram/2` (как в конфиге)
* **Swapfile:** 4–8GB (для 16GB RAM обычно комфортно)
