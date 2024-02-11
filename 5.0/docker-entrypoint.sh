#!/bin/bash

set -euo pipefail

: "${RT_ROOT_PASSWORD:=}"
: "${RT_WEB_PORT:=80}"

sed -i "s/RT_WEB_PORT/$RT_WEB_PORT/" /opt/rt5/etc/RT_SiteConfig.pm

if [[ -n "${RT_ROOT_PASSWORD}" ]]; then
  (echo "${RT_ROOT_PASSWORD}" | /opt/rt5/sbin/rt-passwd root) || [[ $? -gt 1 ]] && exit 1
fi

exec "$@"
