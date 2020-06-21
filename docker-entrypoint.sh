#!/bin/bash

set -euo pipefail

: "${RT_WEB_PORT:=80}"

sed -i "s/RT_WEB_PORT/$RT_WEB_PORT/" /opt/rt%%RT_VERSION_MAJOR%%/etc/RT_SiteConfig.pm

exec "$@"
