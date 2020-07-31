#FROM       debian:jessie
FROM       debian:bullseye
MAINTAINER mehdijrgr

ADD ssl /ssl
ADD scripts /scripts
ADD rabbitmq.config /etc/rabbitmq/rabbitmq.config
RUN chmod +x /scripts/*.sh

RUN apt-get update && \
    apt-get install adduser wget init-system-helpers openssl logrotate socat erlang erlang-nox python -y && \
    apt-get autoclean && \
    apt-get autoremove

ENV RABBITMQ_VERSION 3.8.1
ENV RABBITMQ_SERVER https://github.com/rabbitmq/rabbitmq-server/releases/download
RUN wget https://raw.githubusercontent.com/rabbitmq/rabbitmq-management/v$RABBITMQ_VERSION/bin/rabbitmqadmin && \
    chmod 755 rabbitmqadmin && mv rabbitmqadmin /usr/sbin/

RUN wget $RABBITMQ_SERVER/v$RABBITMQ_VERSION/rabbitmq-server_$RABBITMQ_VERSION-1_all.deb && \
    dpkg -i rabbitmq-server_$RABBITMQ_VERSION-1_all.deb && \
    rm -rf rabbitmq-server_$RABBITMQ_VERSION-1_all.deb && \
    rabbitmq-plugins enable rabbitmq_web_stomp rabbitmq_stomp rabbitmq_management

EXPOSE 5671 61614 15672 5672 61613

CMD ["/scripts/run.sh"]


