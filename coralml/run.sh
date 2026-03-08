#!/usr/bin/env bash
set -e

echo "Starting Coral add-on"
lsusb || true
dmesg | grep -i edgetpu || true

exec python3 -u main.py