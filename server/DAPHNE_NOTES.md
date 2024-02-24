# Daphne Notes

## Install the TLS and HTTP2 with Twisted:

pip install -U 'Twisted[tls,http2]'

## Generate the self-signed cert:

openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout selfsigned.key -out selfsigned.crt

## Run the application:
daphne -e ssl:100001:privateKey=/home/tylersuehr/Downloads/poc/server/selfsigned.key:certKey=/home/tylersuehr/Downloads/poc/server/selfsigned.crt server.asgi:application

## Run the Redis server for Redis channels
docker run --rm -p 6379:6379 redis:7
