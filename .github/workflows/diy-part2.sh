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
# ImmortalWrt Uboot , Target
rm -rf ./target/linux/rockchip
svn co https://github.com/immortalwrt/immortalwrt/branches/master/target/linux/rockchip target/linux/rockchip
rm -rf ./package/boot/uboot-rockchip
svn co https://github.com/immortalwrt/immortalwrt/branches/master/package/boot/uboot-rockchip package/boot/uboot-rockchip
svn co https://github.com/immortalwrt/immortalwrt/branches/master/package/boot/arm-trusted-firmware-rockchip-vendor package/boot/arm-trusted-firmware-rockchip-vendor
rm ./target/linux/rockchip/patches-5.4/9*
rm -rf ./target/linux/rockchip/patches-5.10
chmod +x package/boot/arm-trusted-firmware-rockchip-vendor/pack-firmware.sh

# Patch jsonc
wget -qO- https://github.com/QiuSimons/YAOF/raw/master/PATCH/jsonc/use_json_object_new_int64.patch | patch -p1

# BBRv2
#patch -p1 < ../PATCH/BBRv2/openwrt-kmod-bbr2.patch
#cp -f ../PATCH/BBRv2/693-Add_BBRv2_congestion_control_for_Linux_TCP.patch ./target/linux/generic/hack-5.4/693-Add_BBRv2_congestion_control_for_Linux_TCP.patch
#wget -qO - https://github.com/openwrt/openwrt/commit/cfaf039.patch | patch -p1

# CacULE
wget -qO- https://github.com/QiuSimons/openwrt-NoTengoBattery/commit/7d44cab.patch | patch -p1
wget -qO target/linux/generic/hack-5.4/694-cacule-5.4.patch https://github.com/hamadmarri/cacule-cpu-scheduler/raw/master/patches/CacULE/v5.4/cacule-5.4.patch

#Disable mitigatiions
sed -i 's,rootwait,rootwait mitigations=off,g' target/linux/rockchip/image/nanopi-r4s.bootscript

# Modify default IP
sed -i 's/10.0.0.1/10.0.10.100/g' package/base-files/files/bin/config_generate

#Enable r8168
sed -i 's,kmod-r8169,kmod-r8168,g' target/linux/rockchip/image/armv8.mk

#Use specific optimizations
sed -i 's,-mcpu=generic,-mcpu=cortex-a72.cortex-a53+crypto,g' include/target.mk

#IRQ Tuning
sed -i '/set_interface_core 20 "eth1"/a\set_interface_core 8 "ff3c0000" "ff3c0000.i2c"' target/linux/rockchip/armv8/base-files/etc/hotplug.d/net/40-net-smp-affinity
sed -i '/set_interface_core 20 "eth1"/a\ethtool -C eth0 rx-usecs 1000 rx-frames 25 tx-usecs 100 tx-frames 25' target/linux/rockchip/armv8/base-files/etc/hotplug.d/net/40-net-smp-affinity


# CacULE
sed -i '/CONFIG_NR_CPUS/d'  target/linux/rockchip/armv8/config-5.4
echo '
CONFIG_NR_CPUS=6
CONFIG_CACULE_SCHED=y
CONFIG_CACULE_RDB=y
CONFIG_RDB_INTERVAL=19
' >> ./target/linux/rockchip/armv8/config-5.4

chmod -R 755 ./
