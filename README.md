# <img src="https://raw.githubusercontent.com/SAPPHIVE/onion-pipe-relay/main/src/assets/logo/logo.png" height="32"> Tor Container (maintained by Sapphive)

This is a lightweight, multi-purpose Tor container maintained by the Sapphive Infrastructure Team. It is designed for running hidden services, rotating proxies, and anonymous gateways.

## 🚀 Features
- **Onion Service Mode**: Host any local port as a `.onion` address.
- **Rotating Proxy Mode**: Built-in HAProxy for a single entrypoint with rotating exit circuits.
- **Client Authentication**: Support for authorized_clients.
- **Automated Renewals**: Scripts for rotating identities on a schedule.

## 🐳 Usage

### 1. Basic Onion Service
Expose a local web server (port 80) as an onion service.

```bash
docker run -d \
  -e FORWARD_DEST=http://192.168.1.10:80 \
  -v ./keys:/var/lib/tor/hidden_service \
  sapphive/tor:latest
```

### 2. Rotating SOCKS5 Proxy
Create a proxy that changes its identity every 60 seconds.

```bash
docker run -d \
  -p 9050:9050 \
  -e ROTATE_INTERVAL=60 \
  sapphive/tor:rotating
```

## 📂 Configuration
- `/var/lib/tor/hidden_service`: Volume for persistence of your `.onion` address.
- `FORWARD_DEST`: The target destination (e.g., `http://myserver:8080`).
- `SOCKS_PORT`: Enable SOCKS proxy (default: none).
- `CONTROL_PORT`: Enable Tor control port (default: 9051).

## 🛡️ Security
This image runs Tor as a non-root user and follows security best practices for hidden service isolation.
