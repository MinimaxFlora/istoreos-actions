#!/bin/bash
# ==============================================================================
# 脚本名称: 自定义 Feed 源添加脚本
# 运行阶段: feeds 更新前执行
# 功能说明: 在 feeds.conf.default 文件末尾追加自定义的第三方软件源 / 源码包
# 参考项目: https://github.com/MinimaxFlora/My-OpenWrt-Firmware
# ==============================================================================

# 1. 检查当前是否处于 openwrt 根目录下
if [ ! -f "feeds.conf.default" ]; then
    echo "❌ 错误: 未找到 feeds.conf.default 文件，请确保在 openwrt 根目录执行！"
    exit 1
fi

echo "📦 正在添加自定义扩展源..."

# 2. 追加第三方软件源 (按需取消注释并修改下方地址)
# 格式: src-git <源名称> <Git仓库地址>;<分支名称>
echo "src-git third_party https://github.com/linkease/istore-packages.git;main" >> feeds.conf.default
echo "src-git diskman https://github.com/jjm2473/luci-app-diskman.git;dev" >> feeds.conf.default
echo "src-git oaf https://github.com/jjm2473/OpenAppFilter.git;dev8" >> feeds.conf.default
echo "src-git linkease_nas https://github.com/linkease/nas-packages.git;master" >> feeds.conf.default
echo "src-git linkease_nas_luci https://github.com/linkease/nas-packages-luci.git;main" >> feeds.conf.default
echo "src-git jjm2473_apps https://github.com/jjm2473/openwrt-apps.git;main" >> feeds.conf.default

echo "✨ 自定义 Feed 源配置已完成！"
