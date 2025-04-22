#!/bin/bash

#
# Copyright (c) 2021 Matthew Penner
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.
#

# 預設時區
TZ=${TZ:-UTC}
export TZ

# 設定 Internal IP
INTERNAL_IP=$(ip route get 1 | awk '{print $(NF-2);exit}')
export INTERNAL_IP

# 自動修改預設路由為 Proxy 容器
echo "[entrypoint] Changing default route..."
ip route del default
ip route add default via 172.19.0.10
echo "[entrypoint] Default route set to proxy"

# 切換到工作目錄
cd /home/container || exit 1

# 顯示 Java 版本
printf "\033[1m\033[33mcontainer@pterodactyl~ \033[0mjava -version\n"
java -version

# 解析 STARTUP 變數
PARSED=$(echo "${STARTUP}" | sed -e 's/{{/${/g' -e 's/}}/}/g' | eval echo "$(cat -)")

# 執行實際命令
printf "\033[1m\033[33mcontainer@pterodactyl~ \033[0m%s\n" "$PARSED"
# shellcheck disable=SC2086
exec env ${PARSED}
