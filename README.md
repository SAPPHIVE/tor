# <img src="https://styleguide.torproject.org/static/images/tor-logo/color.svg" width="32"> Sapphive Tor Proxy & Hosting Suite

![Docker Pulls](https://img.shields.io/docker/pulls/sapphive/tor) ![Docker Image Size](https://img.shields.io/docker/image-size/sapphive/tor) ![Build Status](https://github.com/sapphive/tor-docker/actions/workflows/build.yml/badge.svg)

⚠️ **UNOFFICIAL IMAGE** ⚠️

This is an unofficial **Tor Proxy & Hosting Suite** maintained by [SAPPHIVE](https://sapphive.com). It provides an all-in-one solution for standard browsing, automated IP rotation, and secure hidden service hosting.

Built directly from the official [Tor Project repositories](https://deb.torproject.org/).
This project is **not** affiliated with, endorsed by, or sponsored by The Tor Project.

## Why use this suite?

*   **Versatile:** Choose between standard, rotating, or hosting tags based on your needs.
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

### 🧅 Onion Sidecar (Production-Ready Hosting)
Securely host your website or API on the darknet with zero configuration. This "sidecar" provides a production-grade gateway that automatically handles identity generation, port forwarding, and global circuit publishing.

**Capabilities:**
*   **Full CRUD & Routes:** Supports POST requests, file uploads, sessions, and deep subpage routing.
*   **Bypass Everything:** Works behind CGNAT, strict firewalls, and complex corporate networks without opening any ports.
*   **Production Deployment:** Scale from local development to global production hosting instantly via a unique `.onion` URL.

**Quick Start:**
```bash
docker run -d \
  --name tor-gate \
  -e TARGET=website_container:80 \
  -v ./tor-keys:/var/lib/tor/hidden_service \
  sapphive/tor:onion
```

**What to expect in logs (`docker logs tor-gate`):**
```text
***************************************************
 YOUR ONION ADDRESS: xxxxxxxx.onion
***************************************************
```

## � Use Cases

| Service | Best For... | Example |
| :--- | :--- | :--- |
| **Standard** | Privacy & Dev | Anonymous browsing or testing simple app connectivity. |
| **Rotating** | Automation | High-speed web scraping, data mining, and bypassing rate limits. |
| **Onion** | Decentralized Hosting | Publishing blogs, APIs, or internal tools without a public IP or NAT setup. |

## �🏗️ Docker Compose Examples

### Multi-Instance Rotating Proxy
```yaml
services:
  tor:
    image: sapphive/tor:rotating
    environment:
      - TOR_INSTANCES=10
    ports:
      - "9050:9050"
```

### Onion Sidecar Hosting
```yaml
services:
  my-app:
    image: node:alpine
  
  tor-gate:
    image: sapphive/tor:onion
    environment:
      - TARGET=my-app:3000
    volumes:
      - ./tor-keys:/var/lib/tor/hidden_service
```

## ⚙️ Configuration

### Environment Variables

| Variable | Tag | Default | Description |
| :--- | :--- | :--- | :--- |
| `TOR_INSTANCES` | `rotating` | `10` | The number of independent Tor processes to run. |
| `TARGET` | `onion` | `localhost:80` | The internal address of the website to expose. |
| `ONION_PORT` | `onion` | `80` | The port your `.onion` site will listen on. |

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

## ⚖️ Legal Disclaimer
Tor is a trademark of The Tor Project, Inc. This project is a community-driven implementation managed by SAPPHIVE and is not an official product of The Tor Project. All logos and trademarks belong to their respective owners.

