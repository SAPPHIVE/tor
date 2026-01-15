#!/bin/bash

# Configuration with defaults
# Check if TOR_INSTANCES is set and is a valid integer >= 1
if [[ -z "${TOR_INSTANCES}" ]] || ! [[ "${TOR_INSTANCES}" =~ ^[0-9]+$ ]] || [ "${TOR_INSTANCES}" -lt 1 ]; then
    echo "TOR_INSTANCES not set or invalid (< 1). Defaulting to 10 instances."
    INSTANCES=10
else
    INSTANCES=${TOR_INSTANCES}
fi

echo "Generating configuration for $INSTANCES Tor instances..."

# Start with a fresh haproxy config
cat <<EOF > /etc/haproxy/haproxy.cfg
global
    log /dev/log local0
    log /dev/log local1 notice
    maxconn 4096

defaults
    log global
    mode tcp
    option tcplog
    option dontlognull
    timeout connect 5s
    timeout client 1m
    timeout server 1m

frontend tor_proxy
    bind *:9050
    default_backend tor_instances

backend tor_instances
    balance roundrobin
EOF

# Clear supervisord config and add global section
cat <<EOF > /etc/supervisor/conf.d/supervisord.conf
[supervisord]
nodaemon=true
user=root

[program:haproxy]
command=haproxy -f /etc/haproxy/haproxy.cfg
autostart=true
autorestart=true
EOF

# Generate configs for each Tor instance
for i in $(seq 1 $INSTANCES); do
    SOCKS_PORT=$((9050 + i))
    CONTROL_PORT=$((9150 + i))
    DATA_DIR="/var/lib/tor-instances/tor$i"
    
    mkdir -p "$DATA_DIR"
    chown -R debian-tor:debian-tor "$DATA_DIR"
    chmod 700 "$DATA_DIR"

    # Create torrc
    cat <<EOF > "/etc/tor/torrc.$i"
SocksPort 0.0.0.0:$SOCKS_PORT
ControlPort 0.0.0.0:$CONTROL_PORT
DataDirectory $DATA_DIR
CookieAuthentication 1
MaxCircuitDirtiness 30
EOF

    # Add to HAProxy backend
    echo "    server tor$i 127.0.0.1:$SOCKS_PORT check" >> /etc/haproxy/haproxy.cfg

    # Add to Supervisord
    cat <<EOF >> /etc/supervisor/conf.d/supervisord.conf

[program:tor$i]
command=tor -f /etc/tor/torrc.$i
user=debian-tor
autostart=true
autorestart=true
EOF
done

echo "Starting Supervisor..."
exec /usr/bin/supervisord -c /etc/supervisor/conf.d/supervisord.conf
