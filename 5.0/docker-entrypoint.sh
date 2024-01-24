#!/bin/bash

set -euo pipefail

: "${RT_WEB_PORT:=80}"
: "${RT_WEB_DOMAIN:=localhost}"
: "${RT_REDIRECT_URLS:=0}"

sed -i "s/RT_WEB_PORT/$RT_WEB_PORT/" /opt/rt5/etc/RT_SiteConfig.pm
sed -i "s/RT_WEB_DOMAIN/$RT_WEB_DOMAIN/" /opt/rt5/etc/RT_SiteConfig.pm
sed -i "s/RT_REDIRECT_URLS/$RT_REDIRECT_URLS/" /opt/rt5/etc/RT_SiteConfig.pm

if [ -n "${RT_DEFAULT_PASSWORD}" ]; then
    /opt/rt5/sbin/rt-passwd-from-env
fi


exec "$@"
