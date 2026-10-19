
echo "[4] Веб-сервер"
# а) служба nginx активна
check "Служба nginx активна" "active" "$(systemctl is-active nginx)"

# б) конфигурация nginx корректна (код 0 при nginx -t)
if sudo nginx -t > /dev/null 2>&1; then echo "  [OK]   Синтаксис nginx корректен"; ((PASS++)); else echo "  [FAIL] Синтаксис nginx некорректен"; ((FAIL++)); fi

# в) сертификат истекает не ранее чем через 30 дней
if openssl x509 -checkend 2592000 -noout -in /etc/ssl/certs/devops.crt > /dev/null 2>&1; then echo "  [OK]   Сертификат действителен > 30 дней"; ((PASS++)); else echo "  [FAIL] Сертификат истекает < 30 дней"; ((FAIL++)); fi

# г) нет файлов с правом записи для всех, ключ 600
if [[ -z "$(find /var/www/devops-site -perm -o+w 2>/dev/null)" ]]; then echo "  [OK]   Нет файлов, доступных для записи всем"; ((PASS++)); else echo "  [FAIL] Найдены файлы с правом записи для всех"; ((FAIL++)); fi
check "Права ключа TLS 600" "600" "$(sudo stat -c '%a' /etc/ssl/private/devops.key)"
