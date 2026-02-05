#!/bin/bash

# ===========================
# Splunk Universal Forwarder Installer (TGZ)
# ===========================

# --- CONFIGURATION ---

SPLUNK_SERVER_IP="172.20.242.20"         # Change to your Splunk server IP
SPLUNK_RECEIVE_PORT="9997"               # Default receiving port on Splunk server
DOWNLOAD_URL="https://download.splunk.com/products/universalforwarder/releases/10.2.0/linux/splunkforwarder-10.2.0-d749cb17ea65-linux-amd64.tgz"
INSTALL_DIR="/opt"

# --- DOWNLOAD TGZ ---
echo "[*] Downloading Splunk Universal Forwarder..."
wget -O splunkforwarder.tgz "$DOWNLOAD_URL" || { echo "Download failed"; exit 1; }

# --- EXTRACT ---
echo "[*] Extracting Splunk Forwarder to $INSTALL_DIR..."
sudo tar -xzf splunkforwarder.tgz -C $INSTALL_DIR || { echo "Extraction failed"; exit 1; }

SPLUNK_HOME="$INSTALL_DIR/splunkforwarder"

# --- ACCEPT LICENSE AND ENABLE BOOT START ---
echo "[*] Starting Splunk forwarder and accepting license..."
sudo $SPLUNK_HOME/bin/splunk start --accept-license --answer-yes --no-prompt
sudo $SPLUNK_HOME/bin/splunk enable boot-start

# --- CONFIGURE FORWARDING SERVER ---
echo "[*] Adding forward-server $SPLUNK_SERVER_IP:$SPLUNK_RECEIVE_PORT..."
sudo $SPLUNK_HOME/bin/splunk add forward-server $SPLUNK_SERVER_IP:$SPLUNK_RECEIVE_PORT -auth admin:changeme

# --- RESTART FORWARDER ---
echo "[*] Restarting Splunk forwarder..."
sudo $SPLUNK_HOME/bin/splunk restart

echo "[*] Splunk Universal Forwarder installed and configured successfully!"
echo "Forwarding logs to $SPLUNK_SERVER_IP:$SPLUNK_RECEIVE_PORT"
