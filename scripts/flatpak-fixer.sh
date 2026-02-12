#!/bin/bash

# Script to enable unprivileged user namespaces required by Flatpak (bwrap)

set -e

echo "[+] Enabling unprivileged user namespaces..."
sudo sysctl kernel.unprivileged_userns_clone=1

echo "[+] Making the change persistent..."
echo 'kernel.unprivileged_userns_clone=1' | sudo tee /etc/sysctl.d/00-local-userns.conf > /dev/null

echo "[+] Reloading sysctl configuration..."
sudo sysctl --system

echo "[✓] Unprivileged user namespaces are now enabled."

