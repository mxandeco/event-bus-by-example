#!/usr/bin/env sh

# assign defaults
RABBIT_HOST=${RABBIT_HOST:-127.0.0.1}
RABBIT_PORT=${RABBIT_PORT:-15672}
RABBIT_USER=${RABBIT_USER:-guest}
RABBIT_PASSWORD=${RABBIT_PASSWORD:-guest}
RABBIT_VHOST=${RABBIT_VHOST:-/}

OPTIONS="-H $RABBIT_HOST -V $RABBIT_VHOST -P $RABBIT_PORT -u $RABBIT_USER -p $RABBIT_PASSWORD"

echo "boostraping config on $OPTIONS"

/usr/bin/rabbitmqadmin declare exchange name=ebus type=topic durable=true auto_delete=false internal=false ${OPTIONS}

# Declare default retry structure
/usr/bin/rabbitmqadmin declare exchange name=ebus_retry type=topic durable=true auto_delete=false internal=true ${OPTIONS}
/usr/bin/rabbitmqadmin declare queue name=ebus_retry durable=true auto_delete=false ${OPTIONS}
/usr/bin/rabbitmqadmin declare binding source=ebus_retry destination=ebus_retry destination_type=queue routing_key='#' ${OPTIONS}
/usr/bin/rabbitmqadmin declare policy name=ebus_retry pattern="^ebus_retry$" apply-to=queues definition="{\"dead-letter-exchange\": \"ebus\", \"message-ttl\": 180000, \"ha-mode\":	\"all\", \"ha-sync-batch-size\":	128, \"ha-sync-mode\":	\"automatic\", \"queue-mode\":	\"lazy\"}" ${OPTIONS}

# Declare the retry structure for web discarder flow.
# web-stream -> ex_ediscard -> q_ediscard -> ex_ediscard.retry -> WebConsumerDiscard.java -> ex_ediscard or discard.

/usr/bin/rabbitmqadmin declare exchange name=ediscard type=topic durable=true auto_delete=false internal=true ${OPTIONS}
/usr/bin/rabbitmqadmin declare queue name=ediscard durable=true auto_delete=false arguments="{\"x-dead-letter-exchange\":\"ediscard.retry\",\"x-message-ttl\":60000}" ${OPTIONS}
/usr/bin/rabbitmqadmin declare binding source=ediscard destination=ediscard destination_type=queue routing_key='#' ${OPTIONS}

/usr/bin/rabbitmqadmin declare exchange name=ediscard.retry type=topic durable=true auto_delete=false internal=true ${OPTIONS}

# Declare default policies

/usr/bin/rabbitmqadmin declare policy name=ebus_default pattern="^[^web].*#.*\..*$" apply-to=queues definition="{\"dead-letter-exchange\": \"ebus_retry\", \"expires\": 604800000, \"ha-mode\":	\"all\", \"ha-sync-batch-size\": 128, \"ha-sync-mode\":	\"automatic\", \"queue-mode\": \"lazy\"}" ${OPTIONS}

echo "Exchanges:"
/usr/bin/rabbitmqadmin list exchanges ${OPTIONS}

echo "Queues:"
/usr/bin/rabbitmqadmin list queues ${OPTIONS}

echo "Policies:"
/usr/bin/rabbitmqadmin list policies ${OPTIONS}

echo "Bindings:"
/usr/bin/rabbitmqadmin list bindings ${OPTIONS}
