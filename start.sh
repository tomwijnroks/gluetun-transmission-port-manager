#!/bin/bash

CURRENT_PORT=""

# Function to update the transmission port.
update_port() {
  PORT=$1

  # Retrieve and set the transmission session id.
  SESSION_ID=$(
    curl -s http://${TRANSMISSION_HOST}:${TRANSMISSION_PORT}/transmission/rpc \
      -u ${TRANSMISSION_USERNAME}:${TRANSMISSION_PASSWORD} | \
    grep -oP '(?<=X-Transmission-Session-Id: )\w+'
  )

  # Set the forwarded port as peer-port in transmission.
  curl -s http://${TRANSMISSION_HOST}:${TRANSMISSION_PORT}/transmission/rpc \
    -u ${TRANSMISSION_USERNAME}:${TRANSMISSION_PASSWORD} \
    -H "X-Transmission-Session-Id: $SESSION_ID" \
    -H "Content-Type: application/json" \
    -d "{\"arguments\": {\"peer-port\": $PORT}, \"method\": \"session-set\"}" \
    >/dev/null

  # Check the current peer-port in transmission.
  CURRENT_PORT=$(
    curl -s http://${TRANSMISSION_HOST}:${TRANSMISSION_PORT}/transmission/rpc \
      -u ${TRANSMISSION_USERNAME}:${TRANSMISSION_PASSWORD} \
      -H "X-Transmission-Session-Id: $SESSION_ID" \
      -H "Content-Type: application/json" \
      -d "{\"arguments\": {\"fields\": [\"peer-port\"]}, \"method\": \"session-get\"}" | \
    jq ".arguments[\"peer-port\"]"
  )

  if [ "${CURRENT_PORT}" == "${PORT}" ]; then
    echo "${DATETIME} - Successfully updated Transmission to port ${PORT}"
    return 0
  else
    echo "${DATETIME} - Failed to update port."
    return 1
  fi

  # Unset the transmission session id.
  SESSION_ID=""

  # Print info if the transmission port has changed.
  echo "${DATETIME} Successfully updated Transmission to port ${PORT}"
}

while true; do
  # Set the datetime.
  DATETIME=$(date +"%FT%T")

  # Retrieve the forwarded port from gluetun.
  PORT_FORWARDED=$(
    curl -s http://${GLUETUN_HOST}:${GLUETUN_PORT}/v1/openvpn/portforwarded \
      -u ${GLUETUN_USERNAME}:${GLUETUN_PASSWORD} | \
    jq '.port'
  )

  # Check if the forwarded port is a valid port number (1-65535).
  if [[ -z "${PORT_FORWARDED}" || \
        ! "${PORT_FORWARDED}" =~ ^[0-9]+$ || \
        "${PORT_FORWARDED}" -lt 1 || \
        "${PORT_FORWARDED}" -gt 65535 ]]; then
    echo "${DATETIME} - Failed to retrieve a valid port number."
    sleep 10
    continue
  fi

  # If the current port and forwared port are not equal, execute the update_port function.
  if [ "${CURRENT_PORT}" != "${PORT_FORWARDED}" ]; then
    update_port "${PORT_FORWARDED}"
  fi

  # Sleep until the next interval.
  sleep ${PORT_CHECK_INTERVAL}

  # Unset the datetime.
  DATETIME=""
done
