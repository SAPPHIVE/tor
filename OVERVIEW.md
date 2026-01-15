# <img src="https://styleguide.torproject.org/static/images/tor-logo/color.svg" width="32"> Sapphive Tor Client

![Docker Pulls](https://img.shields.io/docker/pulls/sapphive/tor) ![Docker Image Size](https://img.shields.io/docker/image-size/sapphive/tor) ![Build Status](https://github.com/sapphive/tor-docker/actions/workflows/build.yml/badge.svg)

⚠️ **UNOFFICIAL IMAGE**
*This is an unofficial Tor client image maintained by [SAPPHIVE](https://sapphive.com). It is built directly from official [Tor Project repositories](https://deb.torproject.org/). This project is not affiliated with, endorsed by, or sponsored by The Tor Project.*

---

## 🚀 Overview

This image provides a production-hardened, automatically updated Tor client. It is designed for developers and DevOps teams who need a reliable, up-to-date Tor SOCKS5 proxy without the maintenance overhead.

### Key Features:
*   🛡️ **Security Hardened:** Runs as a non-root user (`debian-tor`).
*   🔄 **IP Rotation:** Optional `rotating` tag for high-performance scraping and identity rotation.
*   🔄 **Fully Automated:** Rebuilt weekly to ensure the latest Tor binary and OS security patches.
*   🩺 **Integrated Healthchecks:** Periodic internal checks verify the SOCKS5 proxy is active.

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
docker run -d \
  --name tor-rotating \
  -p 9050:9050 \
  -e TOR_INSTANCES=10 \
  sapphive/tor:rotating
```
*Port 9050 provides a single entry point that load-balances between multiple identities.*

---

## 🏷️ Supported Tags
*   `latest`, `stable`: Single Tor instance (Slim image).
*   `rotating`: Multi-instance Tor proxy with built-in HAProxy load balancing.
*   `0.4.x.x`: Specific Tor versions for high-stability environments.

---

## 🤝 Maintainer & Support
Maintained by **SAPPHIVE Infrastructure Team**.
*   **Website:** [sapphive.com](https://sapphive.com)
*   **Support:** [support@sapphive.com](mailto:support@sapphive.com)
*   **Source:** [GitHub: sapphive/tor-docker](https://github.com/sapphive/tor-docker)

## ⚖️ Legal Disclaimer
Tor is a trademark of The Tor Project, Inc. Use of the Tor trademark is for descriptive purposes only.
