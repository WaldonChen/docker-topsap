FROM ubuntu:20.04

ENV LANG=C.UTF-8 LC_ALL=C.UTF-8
ENV SERVER_ADDRESS=""
ENV USER_NAME=""
ENV PASSWORD=""

ARG TOPSAP_VERSION="3.5.2.36.2"

WORKDIR /home/work

RUN set -eux; \
  arch="$(dpkg --print-architecture)"; \
  case "$arch" in \
  'x86_64') \
  export ARCH='x86_64'; \
  ;; \
  'arm64' | 'aarch64') \
  export ARCH='aarch64'; \
  ;; \
  'mips64') \
  export ARCH='mips64'; \
  ;; \
  *) echo >&2 "error: unsupported architecture '$arch'"; exit 1 ;; \
  esac; \
  url="https://app.topsec.com.cn/vpn/sslvpnclient/TopSAP-${TOPSAP_VERSION}}-${ARCH}.deb"; \
  echo "Build topsap image for architecture '${ARCH}'"; \
  export DEBIAN_FRONTEND=noninteractive && \
  ln -fs /usr/share/zoneinfo/Asia /etc/localtime && \
  sed -i 's@//ports.ubuntu.com@//mirrors.ustc.edu.cn@g' /etc/apt/sources.list && \
  packages=(tzdata sudo curl dante-server iproute2 ca-certificates iptables psmisc cron expect net-tools) && \
  apt-get update && apt-get -y --no-install-suggests --no-install-recommends --fix-missing install $packages && \
  dpkg-reconfigure --frontend noninteractive tzdata && \
  curl -o topsap.deb $url && dpkg -i topsap.deb && rm -r topsap.deb && \
  rm -rf /var/lib/apt/lists/*

COPY start.sh expect.exp ./
COPY danted.conf /etc

CMD chmod +x start.sh && /home/work/start.sh
