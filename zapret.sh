#!/bin/sh

echo ""
echo ""
echo ""
echo ""
echo ""
echo "-----------------------------------"
echo -e "\e[32mZapret Install\e[0m"
echo "-----------------------------------"
echo ""
echo ""
echo ""
echo ""
echo ""

# 1. Создать скрипт для автоматического получения конфига
cat > /etc/init.d/getdomains << EOF
#!/bin/sh /etc/rc.common

START=99

start () {
    VPN_NOT_WOKRING=$(sing-box -c /etc/sing-box/config.json tools fetch instagram.com 2>&1 | grep FATAL)
    if [ -z "${VPN_NOT_WOKRING}" ]
    then
        # WITHOUT YOUTUBE
        DOMAINS=https://raw.githubusercontent.com/AnotherProksY/allow-domains/main/Russia/inside-dnsmasq-nfset.lst
    else
        # WITH YOUTUBE
        DOMAINS=https://raw.githubusercontent.com/AnotherProksY/allow-domains-no-youtube/main/Russia/inside-dnsmasq-nfset.lst
    fi

    count=0
    while true; do
        if curl -m 3 github.com; then
            curl -f $DOMAINS --output /tmp/dnsmasq.d/domains.lst
            break
        else
            echo "GitHub is not available. Check the internet availability [$count]"
            count=$((count+1))
        fi
    done

    if dnsmasq --conf-file=/tmp/dnsmasq.d/domains.lst --test 2>&1 | grep -q "syntax check OK"; then
        /etc/init.d/dnsmasq restart
    fi
}

EOF

# Даем права на выполнение
chmod +x /etc/init.d/getdomains

# Обновляем пакеты
opkg update

# Скачиваем и устанавливаем пакеты
wget -O /tmp/zapret.ipk https://raw.githubusercontent.com/ritascarlet/testforwork/main/zapret_70.20250213_aarch64_cortex-a53.ipk
wget -O /tmp/luciapp.ipk https://raw.githubusercontent.com/ritascarlet/testforwork/main/luci-app-zapret_70.20250213_all.ipk

if opkg install /tmp/zapret.ipk; then
    echo "Zapret installed successfully."
else
    echo "Failed to install Zapret."
    exit 1
fi

if opkg install /tmp/luciapp.ipk; then
    echo "LuCI app installed successfully."
else
    echo "Failed to install LuCI app."
    exit 1
fi

# Удаляем временные файлы
rm /tmp/zapret.ipk
rm /tmp/luciapp.ipk

# Запускаем getdomains
/etc/init.d/getdomains start

# Добавляем в автозагрузку
/etc/init.d/getdomains enable

echo ""
echo ""
echo ""
echo ""
echo ""
echo "-----------------------------------"
echo -e "\e[32mDone!!!\e[0m"
echo "-----------------------------------"
echo ""
echo ""
echo ""
echo ""
echo ""
