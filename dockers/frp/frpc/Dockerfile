FROM alpine:latest
ENV FRP_VERSION 0.49.0
ENV OS linux_arm64

RUN apk update \
 && apk add --no-cache curl
RUN cd /root \
    && curl -OL https://github.com/fatedier/frp/releases/download/v${FRP_VERSION}/frp_${FRP_VERSION}_${OS}.tar.gz \
    && tar zxvf frp_${FRP_VERSION}_${OS}.tar.gz \
    &&  cd frp_${FRP_VERSION}_${OS}/ \
    &&  cp frpc /usr/bin/  \
    &&  cd /root \
    &&  rm frp_${FRP_VERSION}_${OS}.tar.gz \
    &&  rm -rf frp_${FRP_VERSION}_${OS}/
ENTRYPOINT /usr/bin/frpc -c /etc/frp/frpc.ini
