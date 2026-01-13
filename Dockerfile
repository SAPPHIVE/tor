FROM debian:stable-slim

LABEL maintainer="SAPPHIVE <support@sapphive.com>"
LABEL org.opencontainers.image.source="https://github.com/sapphive/tor-docker"
LABEL org.opencontainers.image.description="Unofficial Tor client image built from Tor Project repositories"

# Install dependencies and Tor
RUN apt update && \
    apt install -y --no-install-recommends \
    curl \
    gnupg \
    ca-certificates \
    procps && \
    curl https://deb.torproject.org/torproject.org/A3C4F0F979CAA22CDBA8F512EE8CBC9E886DDD89.asc \
      | gpg --dearmor > /usr/share/keyrings/tor-archive-keyring.gpg && \
    echo "deb [signed-by=/usr/share/keyrings/tor-archive-keyring.gpg] https://deb.torproject.org/torproject.org stable main" \
      > /etc/apt/sources.list.d/tor.list && \
    apt update && \
    apt install -y --no-install-recommends tor && \
    apt clean && rm -rf /var/lib/apt/lists/*

# Expose Tor SOCKS port
EXPOSE 9050

# Set up Tor configuration to run as a non-root user
# The 'tor' package creates a 'debian-tor' user.
RUN mkdir -p /var/lib/tor && \
    chown -R debian-tor:debian-tor /var/lib/tor && \
    chmod 700 /var/lib/tor

USER debian-tor

# Healthcheck to ensure Tor is working
HEALTHCHECK --interval=60s --timeout=15s --start-period=20s --retries=3 \
    CMD curl --socks5-hostname localhost:9050 https://check.torproject.org/ || exit 1

# Command to run Tor
# We bind SocksPort to 0.0.0.0 so it's accessible from outside the container
CMD ["tor", "SocksPort", "0.0.0.0:9050"]
