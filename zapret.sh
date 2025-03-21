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
    DOMAINS=https://raw.githubusercontent.com/AnotherProksY/allow-domains-no-youtube/main/Russia/inside-dnsmasq-nfset.lst
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


opkg update


wget -O /tmp/zapret.ipk https://raw.githubusercontent.com/ritascarlet/testforwork/main/zapret_70.20250213_aarch64_cortex-a53.ipk

wget -O /tmp/luciapp.ipk https://github.com/ritascarlet/testforwork/raw/refs/heads/main/luci-app-zapret_70.20250213_all.ipk


opkg install /tmp/zapret.ipk

opkg install /tmp/luciapp.ipk

rm /tmp/zapret.ipk

rm /tmp/luciapp.ipk

/etc/init.d/getdomains start



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
