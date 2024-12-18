FROM ubuntu:latest
ENV FILENAME Xray-linux-64.zip 

RUN apt update \
 && apt install  curl zip iptables iproute2 -y
RUN apt install vim -y
RUN cd /root \
    && curl -OL https://github.com/XTLS/Xray-core/releases/latest/download/${FILENAME} \
    && unzip ${FILENAME} \
    && curl -OL  https://github.com/Loyalsoldier/v2ray-rules-dat/releases/latest/download/geoip.dat \
    && curl -OL  https://github.com/Loyalsoldier/v2ray-rules-dat/releases/latest/download/geosite.dat 

RUN cd /root \
    && curl -OL  https://github.com/wi1dcard/v2ray-exporter/releases/download/v0.6.0/v2ray-exporter_linux_amd64 

RUN mv /root/v2ray-exporter_linux_amd64 /root/v2ray-exporter
RUN chmod +x /root/v2ray-exporter

COPY xray.sh /root/xray.sh
RUN chmod +x /root/xray.sh
