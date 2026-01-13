# Sapphive Tor Docker Image

![Docker Pulls](https://img.shields.io/docker/pulls/sapphive/tor)
![Docker Image Size](https://img.shields.io/docker/image-size/sapphive/tor)
![License](https://img.shields.io/github/license/sapphive/tor-docker)

⚠️ **UNOFFICIAL IMAGE** ⚠️

This is an unofficial Tor client image maintained by [SAPPHIVE](https://sapphive.com).
Built directly from the official [Tor Project repositories](https://deb.torproject.org/).
This project is **not** affiliated with, endorsed by, or sponsored by The Tor Project.

## Why use this image?

*   **Up-to-date:** Automatically rebuilt weekly to ensure the latest Tor version and security patches.
*   **Production-grade:** Includes healthchecks and runs as a non-root user.
*   **Official Sources:** Built using the Tor Project's own Debian repositories.

## Quick Start

```bash
docker run -d --name tor -p 9050:9050 sapphive/tor
```

You can now use the Tor proxy at `localhost:9050`.

## Configuration

This image runs Tor with the default configuration, exposing the SOCKS port on `0.0.0.0:9050`.

If you need to provide a custom `torrc`, you can mount it:

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
