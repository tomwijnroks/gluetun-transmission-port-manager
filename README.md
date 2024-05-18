# gluetun-qbittorrent Port Manager
Automatically updates the listening port for qbittorrent to the port forwarded by [Gluetun](https://github.com/qdm12/gluetun/).

## Description
This is my fork of snoringdragon's gluetun qbittorrent forward tool.  

[Gluetun](https://github.com/qdm12/gluetun/) has the ability to forward ports for supported VPN providers, 
but qbittorrent does not have the ability to update its listening port dynamically.
I modified the script by snoringdragon to reach out to the [Gluetun](https://github.com/qdm12/gluetun/) control server API and updates the qbittorrent's listening port based on the response.

## Setup
First, ensure you are able to successfully connect qbittorrent to the forwarded port manually (can be seen by a green globe at the bottom of the WebUI).

Finally, insert the template in `docker-compose.yml` into your docker-compose containing gluetun, substituting the default values for your own.
