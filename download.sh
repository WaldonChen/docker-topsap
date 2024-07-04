#!/bin/bash

TOPSAP_VERSION=${1:-3.5.2.40.2}

case $(uname -m) in
x86_64 | amd64)
  TARGETARCH=x86_64
  URL=https://app.topsec.com.cn/linux/general/${TARGETARCH}/deb/TopSAP-${TOPSAP_VERSION}-${TARGETARCH}.deb
  ;;
arm64 | aarch64)
  TARGETARCH=aarch64
  URL=https://app.topsec.com.cn/linux/general/${TARGETARCH}/TopSAP-${TOPSAP_VERSION}-${TARGETARCH}.deb
  ;;
*)
  echo "Unknown Architecture '$(uname -m)'"
  exit 1
  ;;
esac

echo "Downloading TopSAP-${TOPSAP_VERSION}-${TARGETARCH}.deb ..."
curl -L ${URL} -o TopSAP.deb
