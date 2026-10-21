# Конфигурация виртуальной машины devops-vm

## 1. Параметры машины
- ОЗУ: 2048 МБ
- Ядра CPU: 2
- Диск: 25 ГБ

## 2. Сетевые интерфейсы
- enp0s3: NAT (10.0.2.15)
- enp0s8: Host-only (192.168.56.101)

## 3. Правило проброса портов
- Хост: 127.0.0.1:2222 -> Гость: 2222 (SSH)

## 4. Учётные записи
- student (sudo)
- devops (sudo, ключевой вход)

## 5. Служба SSH
- Порт 2222
- PermitRootLogin no
- PasswordAuthentication no
- MaxAuthTries 3
- AllowUsers devops

## 6. Правила межсетевого экрана
- deny incoming, allow outgoing
- 2222/tcp (LIMIT), 80/tcp, 443/tcp

## 7. Снимки состояния
- 01-clean-install
- 02-keys-configured
- 03-ssh-hardened
- 04-nginx-https

## 8. Веб-сервер
- Пакет: nginx
- Конфигурация: /etc/nginx/sites-available/devops-site
- Каталог ресурса: /var/www/devops-site, владелец devops:devops, права 755/644
- Сертификат: /etc/ssl/certs/devops.crt (644), ключ: /etc/ssl/private/devops.key (600, root)
- Команда формирования: sudo openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout /etc/ssl/private/devops.key -out /etc/ssl/certs/devops.crt -subj "/CN=devops.local" -addext "subjectAltName=DNS:devops.local"
