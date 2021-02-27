FROM ubuntu:20.04

USER root

COPY ./assets /usr/local

ENV ENVIP=""

RUN apt-get update && \
    apt-get install -y \
        apt-utils \
        clamav \
        clamav-daemon \
        curl \
        host \
        inotify-tools \
        supervisor \
        tar \
        transmission-cli \
        wget && \
    mkdir -p /var/log/supervisor && \
    mkdir -p /var/log/cron && \
    cd /usr/local/ && chmod +x *.sh && sync && \
    cd /usr/local/bin && chmod +x *.sh && sync && \
    /usr/local/install_antivirus.sh && \
    apt-get -y remove curl apt-utils && \
    rm -rf /var/cache/* && \
    freshclam

ENTRYPOINT ["/usr/local/entrypoint.sh"]
