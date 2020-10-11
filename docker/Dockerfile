FROM python:3

RUN  curl https://raw.githubusercontent.com/rabbitmq/rabbitmq-management/rabbitmq_v3_6_1/bin/rabbitmqadmin -o /usr/bin/rabbitmqadmin && \
  chmod +x /usr/bin/rabbitmqadmin

ENV RABBIT_HOST=127.0.0.1 \
  RABBIT_PORT=15672 \
  RABBIT_USER=guest \
  RABBIT_PASSWORD=guest \
  RABBIT_VHOST=/

COPY docker-entrypoint.sh /docker-entrypoint.sh

ENTRYPOINT ["/docker-entrypoint.sh"]