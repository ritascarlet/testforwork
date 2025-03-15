#!/bin/sh

wget http://192.168.31.111:8000/openwrt-init.ubi

ubiformat /dev/mtd9 -y -f /tmp/openwrt-init.ubi
nvram set boot_wait=on
nvram set uart_en=1
nvram set flag_boot_rootfs=1
nvram set flag_last_success=1
nvram set flag_boot_success=1
nvram set flag_try_sys1_failed=0
nvram set flag_try_sys2_failed=0
nvram commit
reboot
