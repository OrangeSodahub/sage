#!/bin/bash
function red_echo()
{
    # ANSI: background red (41), foreground white (37)
    printf '\033[41;37m%s\033[0m\n' "$*"
}

function get_script_path()
{
    if [ -n "$BASH_SOURCE" ]; then
        # Bash shell
        _SCRIPT_PATH=$(readlink -f "$BASH_SOURCE")
        echo $_SCRIPT_PATH
        return 0
    elif [ -n "$ZSH_NAME" ]; then
        # Zsh shell
        _SCRIPT_PATH=$(dirname "$0")/$(basename "$0")
        _SCRIPT_PATH=$(readlink -f "$SCRIPT_PATH")
        echo $_SCRIPT_PATH
        return 0
    else
        echo "Unknown shell type"
        return 1
    fi
}
function set_proxy()
{
    rich -p "[bold cyan]> Setting proxy...[/]"
    export http_proxy='http://sys-proxy-rd-relay.byted.org:8118'
    export https_proxy='http://sys-proxy-rd-relay.byted.org:8118'
    export no_proxy='.byted.org'
}
function unset_proxy()
{
    unset http_proxy
    unset https_proxy
    unset no_proxy
    rich -p "[bold cyan]> Proxy unset[/]"
}
SCRIPT_DIR=$(dirname $(get_script_path))
SIMKIT_DIR=$(realpath $SCRIPT_DIR/../)
cd $SIMKIT_DIR
set_proxy
uv tool install rich-cli
REQUIRED_VERSION_MAJOR=535
REQUIRED_VERSION_MINOR=129
red_echo "[Vulkan] Minimum required driver: $REQUIRED_VERSION_MAJOR.$REQUIRED_VERSION_MINOR"
rich -p "[bold cyan]> Checking available Vulkan drivers for IsaacSim...(Minimum required version: $REQUIRED_VERSION_MAJOR.$REQUIRED_VERSION_MINOR)[/]"
DRV_HEX=$(vulkaninfo 2>&1 | awk '/driverVersion/ {print $3}')
red_echo "[Vulkan] Parsed driverVersion(hex/int): ${DRV_HEX:-<empty>}"
VERSIONS=( $DRV_HEX )
FIND_AVAILABLE_DRIVER=false
for DRV in ${VERSIONS[@]}; do
    MAJOR=$(( (DRV >> 22) & 0x3ff ))
    MINOR=$(( (DRV >> 14) & 0x0ff ))
    PATCH=$(( (DRV >> 6)  & 0x0ff ))
    # RTX gate
    if [ $MAJOR -lt $REQUIRED_VERSION_MAJOR ] || \
    { [ $MAJOR -eq $REQUIRED_VERSION_MAJOR ] && [ $MINOR -lt $REQUIRED_VERSION_MINOR ]; }; then
        red_echo "[Vulkan] Unsupported driver: $MAJOR.$MINOR.$PATCH (need >= $REQUIRED_VERSION_MAJOR.$REQUIRED_VERSION_MINOR)"
        rich -p "[dim]   Unsupported driver: $MAJOR.$MINOR.$PATCH[/]"
    else
        rich -p "[bold green]   Found available driver: $MAJOR.$MINOR.$PATCH[/]"
        FIND_AVAILABLE_DRIVER=true
        break
    fi
done
if [ "$FIND_AVAILABLE_DRIVER" = false ]; then
    red_echo "[Vulkan] No available driver found. Exiting."
    rich -p "[bold red]> No available driver can be found on this machine, maybe you want add this IP to blacklist?[/]"
    if [ -n "$MY_HOST_IP" ]; then
        rich -p "[bold dim]   $MY_HOST_IP[/]"
    fi
    if [ -n "$MY_HOST_IPV6" ]; then
        rich -p "[bold dim]   $MY_HOST_IPV6[/]"
    fi
    exit 1
fi