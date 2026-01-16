#!/bin/bash
set -e

# Configuration
HIDDEN_SERVICE_DIR="/var/lib/tor/hidden_service"
TARGET_HOST=${TARGET:-"localhost:80"}
TARGET_PROTO=${PROTO:-"http"}

echo "---------------------------------------------------"
echo "Starting Onion Sidecar (maintained by Sapphive)"
echo "Targeting service: $TARGET_PROTO://$TARGET_HOST"
echo "Exposing on .onion: HTTP (80) & HTTPS (443)"
echo "---------------------------------------------------"

# Ensure the hidden service directory exists with correct permissions
mkdir -p "$HIDDEN_SERVICE_DIR"
mkdir -p "/var/lib/tor"
mkdir -p "/run/nginx"
chown -R debian-tor:debian-tor "$HIDDEN_SERVICE_DIR"
chown -R debian-tor:debian-tor "/var/lib/tor"
chmod 700 "$HIDDEN_SERVICE_DIR"
chmod 700 "/var/lib/tor"

# Prepare Nginx configuration
export TARGET_HOST
export TARGET_PROTO
envsubst '${TARGET_HOST} ${TARGET_PROTO}' < /etc/nginx/templates/nginx.conf.template > /etc/nginx/nginx.conf

# Start Nginx in background
nginx -g "daemon on;"

# Generate torrc dynamically
cat <<EOF > /etc/tor/torrc
DataDirectory /var/lib/tor
SocksPort 0
HiddenServiceDir $HIDDEN_SERVICE_DIR/
HiddenServicePort 80 127.0.0.1:80
HiddenServicePort 443 127.0.0.1:443
EOF

# Function to display the onion address
show_hostname() {
    local hostname_file="$HIDDEN_SERVICE_DIR/hostname"
    echo "Waiting for Tor to generate .onion address..."
    while [ ! -f "$hostname_file" ]; do
        sleep 2
    done
    echo "***************************************************"
    echo " 🚀 ONION SIDECAR ACTIVE"
    echo " 📍 PUBLIC ONION: http://$(cat $hostname_file)"
    echo " 🔒 SECURE ONION: https://$(cat $hostname_file)"
    echo "***************************************************"
}

# Start Tor in the background so we can monitor the hostname file
echo "Launching Tor..."
# We use --User debian-tor to drop privileges
tor -f /etc/tor/torrc --User debian-tor &
TOR_PID=$!

# Show the hostname
show_hostname

# Wait for Tor process
wait $TOR_PID
