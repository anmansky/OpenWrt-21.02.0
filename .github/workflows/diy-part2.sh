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
# Modify default IP
sed -i 's/10.0.0.1/10.0.10.100/g' package/base-files/files/bin/config_generate
# add theme atmaterial
# git clone https://github.com/openwrt-develop/luci-theme-atmaterial.git package/luci-theme-atmaterial
