# Gluetun Transmission Port Manager
Automatically updates the listening port for transmission to the port forwarded by [Gluetun](https://github.com/qdm12/gluetun/).

## Description
This has been forked from [patrickaclark/gluetun-qbittorrent-port-manager](https://github.com/patrickaclark/gluetun-qbittorrent-port-manager) and modified for the Transmission BitTorrent client.

The [Gluetun](https://github.com/qdm12/gluetun/) container has the ability to forward dynamically assigned ports from VPN providers, but Transmission is not aware when a port change occurs. This script uses the Gluetun control server to check the assigned port forward. If the forwarded port does not match with the Transmission peer-port, the peer-port will be updated in Transmission.

## Requirements

**Requirements for Transmission:**
 - Valid username and password for rpc authentication.
 - Disable: Randomize port on launch (`peer-port-random-on-start`).
 - Disable: Use port forwarding from my router (`port-forwarding-enabled`).

**Requirements for Gluetun:**
 - Valid username and password for control server authentication.
 - Control server port exposed in Docker (default: 8000).

## Example for docker-compose
Below an example for a `docker-compose.yml` configuration:

```
gluetun-transmission-port-manager:
  image: twxd/gluetun-transmission-port-manager:latest
  environment:
    GLUETUN_HOST: localhost        # Optional (default: localhost)
    GLUETUN_PORT: 8000             # Optional (default: 8000)
    GLUETUN_USERNAME: admin        # Required
    GLUETUN_PASSWORD: secret       # Required
    TRANSMISSION_HOST: localhost   # Optional (default: localhost)
    TRANSMISSION_PORT: 9091        # Optional (default: 9091)
    TRANSMISSION_USERNAME: admin   # Required
    TRANSMISSION_PASSWORD: secret  # Required
    PORT_CHECK_INTERVAL: 60        # Optional (default: 60 seconds)
  network_mode: service:gluetun
  depends_on:
    - gluetun
    - transmission
  restart: unless-stopped
```
