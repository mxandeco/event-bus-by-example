#!/usr/bin/env sh

# assign defaults
RABBIT_HOST=${RABBIT_HOST:-127.0.0.1}
RABBIT_PORT=${RABBIT_PORT:-15672}
RABBIT_USER=${RABBIT_USER:-guest}
RABBIT_PASSWORD=${RABBIT_PASSWORD:-guest}
RABBIT_VHOST=${RABBIT_VHOST:-/}

OPTIONS="-H $RABBIT_HOST -V $RABBIT_VHOST -P $RABBIT_PORT -u $RABBIT_USER -p $RABBIT_PASSWORD"

until /usr/bin/rabbitmqadmin list exchanges ${OPTIONS} >> /dev/null; do
  echo "RabbitMQ is unavailable - waiting"
  sleep 5
done

echo "RabbitMQ is up - creating initial config"

./bootstrap.sh