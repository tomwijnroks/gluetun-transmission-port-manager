FROM linuxcontainers/debian-slim:latest

RUN apt-get update && \
    apt-get install -y bash curl jq && \
    apt-get clean

ENV GLUETUN_HOST=localhost
ENV GLUETUN_PORT=8000
ENV TRANSMISSION_HOST=localhost
ENV TRANSMISSION_PORT=9091
ENV CHECK_PORT_INTERVAL=60

COPY ./start.sh ./start.sh
RUN chmod 770 ./start.sh

CMD ["./start.sh"]
