#!/bin/bash
cd /home/container || exit 1

# Use container disk for temp (system /tmp is only 100MB)
export TMPDIR=/home/container/.tmp
export TMP=/home/container/.tmp
export TEMP=/home/container/.tmp
mkdir -p "${TMPDIR}" 2>/dev/null || true

TZ=${TZ:-UTC}
export TZ

INTERNAL_IP=$(ip route get 1 | awk '{print $(NF-2);exit}')
export INTERNAL_IP

# Auto-detect browser binary, set env vars for Puppeteer/Playwright/Chrome-launcher
for chrome in /usr/bin/chromium /usr/bin/google-chrome /usr/bin/google-chrome-stable; do
    if [ -x "$chrome" ]; then
        export PUPPETEER_EXECUTABLE_PATH="$chrome"
        export PLAYWRIGHT_CHROMIUM_EXECUTABLE_PATH="$chrome"
        export PLAYWRIGHT_EXECUTABLE_PATH="$chrome"
        export CHROME_PATH="$chrome"
        export CHROME_BIN="$chrome"
        export CHROME_TEST_BINARY="$chrome"
        break
    fi
done

echo -e "\033[1;96m
                               _    _____ ____  ___ ___  _   _
                              / \  | ____|  _ \|_ _/ _ \| \ | |
                             / _ \ |  _| | |_) || | | | |  \| |
                            / ___ \| |___|  _ < | | |_| | |\  |
                           /_/   \_\_____|_| \_\___\___/|_| \_|
 
                                 A E R I O N   N E T W O R K
\033[0m"

echo -e "\033[38;5;117m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
echo -e "\033[1;97m User     : \033[96m$(whoami)\033[0m"
echo -e "\033[1;97m Host     : \033[96m$(hostname)\033[0m"
echo -e "\033[1;97m IP       : \033[96m${INTERNAL_IP}\033[0m"
echo -e "\033[1;97m Timezone : \033[96m${TZ}\033[0m"
echo -e "\033[38;5;117m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
echo -e "\033[1;96m🚀 Starting Application...\033[0m\n"

eval ${STARTUP}