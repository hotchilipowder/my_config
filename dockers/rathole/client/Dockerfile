FROM ubuntu:latest

ENV FILENAME rathole-x86_64-unknown-linux-gnu.zip

RUN apt update \
 && apt install curl zip -y
RUN cd /root \
    && curl -OL https://github.com/rapiz1/rathole/releases/latest/download/${FILENAME} \
    && unzip ${FILENAME} \
    && mv rathole /usr/bin/  \
    && cd /root \
    && rm ${FILENAME}
COPY entrypoint.sh /usr/local/bin/rathole-entrypoint
RUN chmod +x /usr/local/bin/rathole-entrypoint
ENTRYPOINT ["/usr/local/bin/rathole-entrypoint", "/etc/rathole/client.toml.template"]
