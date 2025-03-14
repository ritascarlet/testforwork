#!/bin/sh

cat > /etc/hotplug.d/iface/40-getvpnconfig<< EOF
#!/bin/sh

sleep 10

ROUTER_MAC=$(uci show network.@device[1].macaddr | cut -d"'" -f 2 | tr -d ':' | awk '{ print toupper($0) }')
SINGBOX_CONFIG_PATH='/etc/sing-box/config.json'


request_vpn_config() {
    REQUEST_URI="https://getconfig.tgvpnbot.com/getrouterconfig?routermac=$ROUTER_MAC"

    curl $REQUEST_URI > $SINGBOX_CONFIG_PATH

    service sing-box restart
    /etc/init.d/getdomains start
}


if [ -e $SINGBOX_CONFIG_PATH ]
then
    SINGBOX_CONFIG_EMPTY=$(cat $SINGBOX_CONFIG_PATH)
    if [ -z "${SINGBOX_CONFIG_EMPTY}" ]
    then
        request_vpn_config
    else
        exit 0
    fi
else
    request_vpn_config
fi
EOF

cp /etc/hotplug.d/iface/40-getvpnconfig /etc/hotplug.d/net/

chmod +x /etc/hotplug.d/iface/40-getvpnconfig

rm -rf /etc/sing-box/config.json

/etc/hotplug.d/iface/40-getvpnconfig

