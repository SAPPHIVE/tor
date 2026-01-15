# <img src="https://styleguide.torproject.org/static/images/tor-logo/color.svg" width="32"> Sapphive Tor Docker Image

![Docker Pulls](https://img.shields.io/docker/pulls/sapphive/tor) ![Docker Image Size](https://img.shields.io/docker/image-size/sapphive/tor) ![Build Status](https://github.com/sapphive/tor-docker/actions/workflows/build.yml/badge.svg)

⚠️ **UNOFFICIAL IMAGE** ⚠️

This is an unofficial Tor client image maintained by [SAPPHIVE](https://sapphive.com).
Built directly from the official [Tor Project repositories](https://deb.torproject.org/).
This project is **not** affiliated with, endorsed by, or sponsored by The Tor Project.

## Why use this image?

*   **Up-to-date:** Automatically rebuilt weekly to ensure the latest Tor version and security patches.
*   **Production-grade:** Includes healthchecks and runs as a non-root user.
*   **Official Sources:** Built using the Tor Project's own Debian repositories.

## Quick Start

### 🚀 Standard Client (Single Identity)
Ideal for basic anonymity and browsing. This is the slim version (~40MB).
```bash
docker run -d --name tor -p 9050:9050 sapphive/tor:latest
```

### 🔄 Rotating Proxy (Multi-Identity)
Ideal for web scraping and automated testing. It runs multiple Tor instances and load-balances between them for instant IP rotation.
```bash
docker run -d \
  --name tor-rotating \
  -p 9050:9050 \
  -e TOR_INSTANCES=10 \
  sapphive/tor:rotating
```
Test your rotation IP:
`for i in {1..5}; do curl --socks5-hostname localhost:9050 https://check.torproject.org/api/ip; echo; sleep 1; done`

## ⚙️ Configuration

### Environment Variables (Rotating Tag Only)

| Variable | Default | Description |
| :--- | :--- | :--- |
| `TOR_INSTANCES` | `10` | The number of independent Tor processes to run. |

### Advanced: Custom `torrc` (Standard Tag Only)
The standard image uses the default Tor configuration. You can mount your own `torrc` file:

```bash
docker run -d \
  --name tor \
  -p 9050:9050 \
  -v /path/to/your/torrc:/etc/tor/torrc:ro \
  sapphive/tor
```

## Maintainer

Maintained by [SAPPHIVE Support](mailto:support@sapphive.com) / [sapphive.com](https://sapphive.com).

## Legal

Tor is a trademark of The Tor Project, Inc. Use of the Tor trademark in this project is for descriptive purposes only.
