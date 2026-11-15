#!/usr/bin/env bash
# ==============================================================================
# OpenWrt Feed Post-Update Processing Engine
# 运行阶段: feeds 更新后执行 (Post-update)
# 功能说明: 自动清理冲突包、拉取最新定制组件、配置系统优化参数
# 参考项目: https://github.com/MinimaxFlora/istoreos-actions
# ==============================================================================

set -eo pipefail

# ------------------------------------------------------------------------------
# 终端颜色与格式化定义
# ------------------------------------------------------------------------------
if [ -t 1 ]; then
    CLR_RESET='\033[0m'
    CLR_BOLD='\033[1m'
    CLR_RED='\033[31m'
    CLR_GREEN='\033[32m'
    CLR_YELLOW='\033[33m'
    CLR_BLUE='\033[34m'
    CLR_PURPLE='\033[35m'
    CLR_CYAN='\033[36m'
    CLR_GRAY='\033[90m'
else
    CLR_RESET='' CLR_BOLD='' CLR_RED='' CLR_GREEN=''
    CLR_YELLOW='' CLR_BLUE='' CLR_PURPLE='' CLR_CYAN='' CLR_GRAY=''
fi

# ------------------------------------------------------------------------------
# UI 响应与日志输出函数
# ------------------------------------------------------------------------------
log_banner() {
    echo -e "${CLR_CYAN}${CLR_BOLD}"
    echo "=============================================================================="
    echo "  $1"
    echo "=============================================================================="
    echo -e "${CLR_RESET}"
}

log_step() {
    echo -e "\n${CLR_PURPLE}${CLR_BOLD}>>> $1${CLR_RESET}"
}

log_info() {
    echo -e "${CLR_BLUE}[ INFO ]${CLR_RESET} $1"
}

log_success() {
    echo -e "${CLR_GREEN}[  OK  ]${CLR_RESET} $1"
}

log_warn() {
    echo -e "${CLR_YELLOW}[ WARN ]${CLR_RESET} $1"
}

log_error() {
    echo -e "${CLR_RED}[ FAIL ]${CLR_RESET} $1"
}

# ------------------------------------------------------------------------------
# 运行前环境校验
# ------------------------------------------------------------------------------
if [ ! -f "include/version.mk" ]; then
    log_error "未检测到 OpenWrt 根目录特征文件 (include/version.mk)！"
    log_error "请确保在正确的 OpenWrt 源码根目录下运行此脚本。"
    exit 1
fi

START_TIME=$(date +%s)
log_banner "    OpenWrt Post-Update Pipeline Initialization    "

# ------------------------------------------------------------------------------
# 1. 冲突软件包清理
# ------------------------------------------------------------------------------
log_step "阶段 1/5: 清理源码库冲突与冗余组件"

REMOVE_PATHS=(
    "package/system/urngd"
    "package/firmware/intel-microcode"
    "feeds/packages/lang/golang"
    "feeds/packages/lang/rust"
    "feeds/packages/lang/node"
    "feeds/packages/net/xray-core"
    "feeds/packages/net/v2ray-core"
    "feeds/packages/net/v2ray-geodata"
    "feeds/packages/net/sing-box"
    # "feeds/packages/net/samba4"
    "feeds/packages/utils/coremark"
    "feeds/packages/net/zerotier"
    "feeds/packages/net/nginx"
    "feeds/packages/utils/docker"
    "feeds/packages/utils/dockerd"
    "feeds/packages/utils/containerd"
    "feeds/packages/utils/runc"
    "feeds/luci/applications/luci-app-sqm"
    "feeds/packages/net/sqm-scripts"
    "feeds/luci/applications/luci-app-dockerman"
    "feeds/luci/applications/luci-app-filemanager"
)
