# Based on:
#  https://hub.docker.com/r/fluent/fluent-bit/dockerfile
#  https://github.com/chesty/docker-kiwiirc/blob/master/Dockerfile

FROM debian:buster as builder

ENV DEBIAN_FRONTEND noninteractive
ENV WORKDIR /kiwiirc
WORKDIR ${WORKDIR}

# Works with 17.10.06.1
ENV KIWIIRC_VERSION 20.05.24.1
ENV KIWIIRC_ZIP kiwiirc_${KIWIIRC_VERSION}_linux_amd64.zip

RUN apt-get update && \
    apt-get install -y wget unzip apt-utils && \
    apt-get -y upgrade openssl

RUN wget https://kiwiirc.com/downloads/${KIWIIRC_ZIP}
RUN	unzip ${KIWIIRC_ZIP}
RUN rm ${KIWIIRC_ZIP}
RUN mv kiwiirc_linux_amd64/* .
RUN rmdir kiwiirc_linux_amd64


FROM gcr.io/distroless/cc
ENV WORKDIR /kiwiirc
WORKDIR ${WORKDIR}

COPY --from=builder ${WORKDIR} ${WORKDIR}

EXPOSE 80

VOLUME /kiwiirc-data

# COPY docker-entrypoint.sh /kiwiirc/docker-entrypoint.sh

COPY ./config/config.conf /kiwiirc/config.conf
COPY ./config/config.js /etc/kiwiirc/config.js
COPY ./config/client.json /etc/kiwiirc/client.json

# ENTRYPOINT ["/kiwiirc/docker-entrypoint.sh"]

CMD ["/kiwiirc/kiwiirc"]
