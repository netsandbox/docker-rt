#!/bin/bash

set -euo pipefail

: "${RT_CANONICALIZE_REDIRECT_URLS:=0}"
: "${RT_WEB_DOMAIN:=localhost}"
: "${RT_WEB_PORT:=80}"

: "${RT_ROOT_PASSWORD:=}"

sed -i \
  -e "s/RT_CANONICALIZE_REDIRECT_URLS/$RT_CANONICALIZE_REDIRECT_URLS/" \
  -e "s/RT_WEB_DOMAIN/$RT_WEB_DOMAIN/" \
  -e "s/RT_WEB_PORT/$RT_WEB_PORT/" \
  /opt/rt%%RT_VERSION_MAJOR%%/etc/RT_SiteConfig.pm

if [[ -n "${RT_ROOT_PASSWORD}" ]]; then
  (echo "${RT_ROOT_PASSWORD}" | /opt/rt%%RT_VERSION_MAJOR%%/sbin/rt-passwd root) || [[ $? -gt 1 ]] && exit 1
fi

exec "$@"
