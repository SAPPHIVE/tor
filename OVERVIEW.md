# <img src="https://raw.githubusercontent.com/SAPPHIVE/onion-pipe-relay/main/src/assets/logo/logo.png" height="32"> Tor Proxy & Hosting Suite (maintained by Sapphive)

![Docker Pulls](https://img.shields.io/docker/pulls/sapphive/tor) ![Docker Image Size](https://img.shields.io/docker/image-size/sapphive/tor) ![Build Status](https://github.com/sapphive/tor-docker/actions/workflows/build.yml/badge.svg)

⚠️ **UNOFFICIAL IMAGE**
*This is an unofficial Tor client image maintained by [SAPPHIVE](https://sapphive.com). It is built directly from official [Tor Project repositories](https://deb.torproject.org/). This project is not affiliated with, endorsed by, or sponsored by The Tor Project.*

---

## 🚀 Overview

The **Tor Proxy & Hosting Suite (maintained by Sapphive)** is a production-hardened collection of specialized Tor tools. It is designed to solve complex anonymity and hosting challenges with three distinct modes:

*   **Standard Proxy:** High-performance, slim SOCKS5 client.
*   **Rotating Identity:** Multi-instance load balancer for automated IP rotation and web scraping.
*   **Onion Sidecar:** Production-grade hosting gateway that bypasses NAT/Firewalls to expose internal services as `.onion` sites.

Designed for developers and DevOps teams, this suite provides reliable, zero-maintenance infrastructure for both individual privacy and global decentralized hosting.

### Key Features:
*   🛡️ **Security Hardened:** Runs as a non-root user (`debian-tor`).
*   🔄 **IP Rotation:** Optional `rotating` tag for high-performance scraping and identity rotation.
*   🧅 **Onion Hosting:** Optional `onion` tag to instantly "sidecar" any web app into a `.onion` service.
*   🔄 **Fully Automated:** Rebuilt weekly to ensure the latest Tor binary and OS security patches.
*   🩺 **Integrated Healthchecks:** Periodic internal checks verify proxy activity (latest/rotating tags).

---

## 🎯 Use Cases

### 🛡️ Standard Client (`latest`)
*   **Anonymous Browsing:** Route your local browser traffic through a secure SOCKS5 proxy.
*   **Privacy Testing:** Verify how your applications behave when accessed from different global locations.
*   **Lightweight Integration:** Perfect for CLI tools or apps that need basic anonymity with minimal overhead (~40MB).

### 🔄 Rotating Identity (`rotating`)
*   **Web Scraping:** Aggregate data from public sources without hitting IP-based rate limits or bans.
*   **API Load Testing:** Simulate traffic coming from multiple unique identities to test system resiliency.
*   **Market Research:** Access region-locked data or price-comparison sites across different Tor exit nodes.

### 🧅 Onion Sidecar (`onion`)
*   **No-IP Hosting:** Host a website or API from your home computer or local server without needing a Static IP or port forwarding.*   **Security First:** Automatic **SSL Termination**. Expose your service over `https://` with auto-generated self-signed certificates.*   **Bypass Restrictions:** Access your internal dashboard (Grafana, Admin UI) securely while behind strict corporate firewalls or CGNAT.
*   **Secure IoT Gateways:** Connect to your smart home or remote devices using a private `.onion` address that works globally.

---

## 🛠️ Usage

### Standard Client (Single Identity)
Run the latest stable version (slim image ~40MB):
```bash
docker run -d --name tor-client -p 9050:9050 sapphive/tor:latest
```

### Rotating Proxy (Multi-Identity)
For automated rotation, use the multi-instance version:
```bash
docker run -d --name tor-rotating -p 9050:9050 -e TOR_INSTANCES=10 sapphive/tor:rotating
```

### Onion Sidecar (Production-Ready Hosting)
Expose any web service (Nginx, Apache, Node.js, PHP, etc.) as a hidden service instantly.

**Why it's powerful:**
*   🌐 **Production-Ready:** Full support for **CRUD operations** (POST, PUT, DELETE), cookies, and deep **subpage routing**.
*   � **Dual Protocol:** Automatically exposes your service via both **HTTP (80)** and **HTTPS (443)** with built-in SSL termination.
*   🛡️ **NAT & Firewall Bypass:** Works behind CGNAT and strict firewalls. No port forwarding or static IP required.
*   🚀 **Automated Identity:** Dynamically generates your `.onion` address and prints it to your logs on first run.

**Terminal Output Example:**
```text
***************************************************
 🚀 ONION SIDECAR ACTIVE
 📍 PUBLIC ONION: http://v2c3...f4g5.onion
 🔒 SECURE ONION: https://v2c3...f4g5.onion
***************************************************
```

---

## 🏗️ Docker Compose Examples

### 1. Standard Client (`tor:latest`)
```yaml
services:
  tor:
    image: sapphive/tor:latest
    ports:
      - "9050:9050"
```

### 2. Rotating Proxy (`tor:rotating`)
```yaml
services:
  proxy:
    image: sapphive/tor:rotating
    ports:
      - "9050:9050"
    environment:
      - TOR_INSTANCES=10
```

### 3. Onion Sidecar (`tor:onion`)
```yaml
services:
  website:
    image: nginx:alpine
  
  tor-gate:
    image: sapphive/tor:onion
    environment:
      - TARGET=website:80
    volumes:
      - ./tor-keys:/var/lib/tor/hidden_service
```

## 🏷️ Supported Tags
*   `latest`, `stable`: Single Tor instance (Slim image).
*   `rotating`: Multi-instance Tor proxy with built-in load balancing.
*   `onion`: Onion Sidecar for hosting hidden services.

---

## 🤝 Maintainer & Support
Maintained by the **Sapphive Infrastructure Team**.
*   **Website:** [sapphive.com](https://sapphive.com)
*   **Support:** [support@sapphive.com](mailto:support@sapphive.com)
*   **Source:** [GitHub: sapphive/tor-docker](https://github.com/sapphive/tor-docker)

## ⚖️ Legal Disclaimer
Tor is a trademark of The Tor Project, Inc. This project is a community-driven implementation managed by SAPPHIVE and is not an official product of The Tor Project. All logos and trademarks belong to their respective owners.
