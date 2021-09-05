#!/bin/bash
#============================================================
# https://github.com/P3TERX/Actions-OpenWrt
# File name: diy-part2.sh
# Description: OpenWrt DIY script part 2 (After Update feeds)
# Lisence: MIT
# Author: P3TERX
# Blog: https://p3terx.com
#============================================================
#
#chmod +x package/boot/arm-trusted-firmware-rockchip-vendor/pack-firmware.sh
# Patch jsonc
wget -qO- https://github.com/QiuSimons/YAOF/raw/master/PATCH/jsonc/use_json_object_new_int64.patch | patch -p1
# CacULE
wget -qO- https://github.com/QiuSimons/openwrt-NoTengoBattery/commit/7d44cab.patch | patch -p1
wget -qO target/linux/generic/hack-5.4/694-cacule-5.4.patch https://github.com/hamadmarri/cacule-cpu-scheduler/raw/master/patches/CacULE/v5.4/cacule-5.4.patch
# Modify default IP
sed -i 's/10.0.0.1/10.0.10.100/g' package/base-files/files/bin/config_generate
# add theme atmaterial
# git clone https://github.com/openwrt-develop/luci-theme-atmaterial.git package/luci-theme-atmaterial
#使用特定的优化
sed -i 's,-mcpu=generic,-mcpu=cortex-a72.cortex-a53+crypto,g' include/target.mk
#IRQ 调优
sed -i '/set_interface_core 20 "eth1"/a\set_interface_core 8 "ff3c0000" "ff3c0000.i2c"' target/linux/rockchip/armv8/base-files/etc/hotplug.d/net/40-net-smp-affinity
sed -i '/set_interface_core 20 "eth1"/a\ethtool -C eth0 rx-usecs 1000 rx-frames 25 tx-usecs 100 tx-frames 25' target/linux/rockchip/armv8/base-files/etc/hotplug.d/net/40-net-smp-affinity


# CacULE
sed -i '/CONFIG_NR_CPUS/d' ./target/linux/rockchip/armv8/config-5.4
echo '
CONFIG_NR_CPUS=6
CONFIG_CACULE_SCHED=y
CONFIG_CACULE_RDB=y
CONFIG_RDB_INTERVAL=19
' >> ./target/linux/rockchip/armv8/config-5.4

chmod -R 755 ./
