FROM ubuntu:20.04
ARG TOPSAP_VERSION="3.5.2.40.2"

WORKDIR /home/work

ENV LANG=C.UTF-8 LC_ALL=C.UTF-8

ENV SERVER_ADDRESS=""
ENV USER_NAME=""
ENV PASSWORD=""

ADD download.sh .

RUN export DEBIAN_FRONTEND=noninteractive && \
  ln -fs /usr/share/zoneinfo/Asia /etc/localtime && \
  sed -i 's@//ports.ubuntu.com@//mirrors.ustc.edu.cn@g' /etc/apt/sources.list && \
  apt-get update && apt-get -y --no-install-suggests --no-install-recommends install tzdata sudo curl dante-server iproute2 ca-certificates iptables psmisc cron && \
  dpkg-reconfigure --frontend noninteractive tzdata && \
  sh download.sh ${TOPSAP_VERSION} && \
  dpkg -i TopSAP.deb && rm -r download.sh TopSAP.deb && \
  apt-get install -y expect && \
  rm -rf /var/lib/apt/lists/*

COPY start.sh .
COPY danted.conf /etc
COPY expect.exp .

CMD chmod +x start.sh && /home/work/start.sh
