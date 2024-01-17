FROM alpine:latest

ENV FILENAME rathole-x86_64-unknown-linux-musl.zip

RUN apk update \
 && apk add --no-cache curl zip
RUN cd /root \
    && curl -OL https://github.com/rapiz1/rathole/releases/latest/download/${FILENAME} \
    && unzip ${FILENAME} \
    && mv rathole /usr/bin/  \
    && cd /root \
    && rm ${FILENAME}
ENTRYPOINT /usr/bin/rathole /etc/rathole/server.toml
