#!/bin/bash
# Log file for debugging
LOGFILE="/tmp/uci-defaults-log.txt"
echo "Starting 99-custom.sh at $(date)" >> $LOGFILE
# yml 传入的路由器型号 PROFILE
echo "Building for profile: $PROFILE"
# yml 传入的固件大小 ROOTFS_PARTSIZE
echo "Building for ROOTFS_PARTSIZE: $ROOTFS_PARTSIZE"

echo "Create pppoe-settings"
mkdir -p  /home/build/immortalwrt/files/etc/config

# 创建pppoe配置文件 yml传入环境变量ENABLE_PPPOE等 写入配置文件 供99-custom.sh读取
cat << EOF > /home/build/immortalwrt/files/etc/config/pppoe-settings
enable_pppoe=${ENABLE_PPPOE}
pppoe_account=${PPPOE_ACCOUNT}
pppoe_password=${PPPOE_PASSWORD}
EOF

echo "cat pppoe-settings"
cat /home/build/immortalwrt/files/etc/config/pppoe-settings


# 输出调试信息
echo "$(date '+%Y-%m-%d %H:%M:%S') - Starting build process..."


# 定义所需安装的包列表 23.05.4 下列插件你都可以自行删减
PACKAGES=""
PACKAGES="$PACKAGES curl"
PACKAGES="$PACKAGES luci-i18n-diskman-zh-cn"
PACKAGES="$PACKAGES luci-i18n-opkg-zh-cn"
PACKAGES="$PACKAGES luci-i18n-firewall-zh-cn"
PACKAGES="$PACKAGES luci-i18n-filebrowser-zh-cn"
PACKAGES="$PACKAGES luci-app-argon-config"
PACKAGES="$PACKAGES luci-i18n-argon-config-zh-cn"
PACKAGES="$PACKAGES luci-i18n-ttyd-zh-cn"
PACKAGES="$PACKAGES luci-i18n-passwall-zh-cn"
PACKAGES="$PACKAGES luci-app-openclash"
PACKAGES="$PACKAGES luci-i18n-homeproxy-zh-cn"
PACKAGES="$PACKAGES openssh-sftp-server"
PACKAGES="$PACKAGES luci-i18n-dockerman-zh-cn"
PACKAGES="$PACKAGES kmod-mt7922-firmware"
PACKAGES="$PACKAGES kmod-mt7921e"
PACKAGES="$PACKAGES kmod-ath11k-pci"
PACKAGES="$PACKAGES luci-proto-quectel"
PACKAGES="$PACKAGES quectel-cm"
PACKAGES="$PACKAGES luci-i18n-sms-tool-js-zh-cn"
PACKAGES="$PACKAGES luci-i18n-cpufreq-zh-cn"
PACKAGES="$PACKAGES luci-i18n-aria2-zh-cn"
PACKAGES="$PACKAGES luci-i18n-qbittorrent-zh-cn"
PACKAGES="$PACKAGES luci-i18n-alist-zh-cn"
PACKAGES="$PACKAGES luci-i18n-transmission-zh-cn"
PACKAGES="$PACKAGES luci-i18n-rclone-zh-cn"
PACKAGES="$PACKAGES luci-i18n-vsftpd-zh-cn"
PACKAGES="$PACKAGES luci-i18n-minidlna-zh-cn"
PACKAGES="$PACKAGES luci-i18n-arpbind-zh-cn"
PACKAGES="$PACKAGES luci-i18n-smartdns-zh-cn"
PACKAGES="$PACKAGES luci-i18n-ddns-zh-cn"
PACKAGES="$PACKAGES luci-i18n-battstatus-zh-cn"
PACKAGES="$PACKAGES luci-i18n-upnp-zh-cn"
PACKAGES="$PACKAGES luci-i18n-openvpn-zh-cn"
PACKAGES="$PACKAGES luci-i18n-zerotier-zh-cn"
PACKAGES="$PACKAGES luci-proto-ncm"
PACKAGES="$PACKAGES luci-proto-mbim"
PACKAGES="$PACKAGES luci-i18n-modemband-zh-cn"
PACKAGES="$PACKAGES luci-proto-modemmanager"
PACKAGES="$PACKAGES luci-proto-qmi"
# 增加几个必备组件 方便用户安装iStore
PACKAGES="$PACKAGES fdisk"
PACKAGES="$PACKAGES script-utils"
PACKAGES="$PACKAGES luci-i18n-samba4-zh-cn"

# 构建镜像
echo "$(date '+%Y-%m-%d %H:%M:%S') - Building image with the following packages:"
echo "$PACKAGES"

make image PROFILE=$PROFILE PACKAGES="$PACKAGES" FILES="/home/build/immortalwrt/files" ROOTFS_PARTSIZE=$ROOTFS_PARTSIZE

if [ $? -ne 0 ]; then
    echo "$(date '+%Y-%m-%d %H:%M:%S') - Error: Build failed!"
    exit 1
fi

echo "$(date '+%Y-%m-%d %H:%M:%S') - Build completed successfully."
