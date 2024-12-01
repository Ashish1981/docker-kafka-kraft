# FROM eclipse-temurin:8u402-b06-jre-alpine
FROM ibm-semeru-runtimes:open-11-jre-jammy

WORKDIR /opt

ARG kafkaversion=3.9.0
ARG scalaversion=2.13

ENV KRAFT_CONTAINER_HOST_NAME=
ENV KRAFT_CREATE_TOPICS=
ENV KRAFT_PARTITIONS_PER_TOPIC=
ENV KRAFT_AUTO_CREATE_TOPICS=

RUN set -eux ; \
    apt-get update ; \
    apt-get upgrade -y ; \
    apt-get install -y --no-install-recommends jq net-tools curl wget ; 

RUN curl -o kafka.tgz https://mirrors.ocf.berkeley.edu/apache/kafka/${kafkaversion}/kafka_${scalaversion}-${kafkaversion}.tgz \
    && tar xvzf kafka.tgz \
    && mv kafka_${scalaversion}-${kafkaversion} kafka \
    && mkdir -p /opt/kafka/data

WORKDIR /opt/kafka

COPY ./configs/server.properties ./config/kraft
COPY ./*.sh .

EXPOSE 9092 9093
VOLUME [ "/opt/kafka/data" , "/opt/kafka/logs", "/opt/kafka/config/kraft"]
ENTRYPOINT [ "./docker-entrypoint.sh" ]
