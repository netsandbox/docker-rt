#!/bin/bash

set -euo pipefail

declare -A versions=(
  [4.2.16]='1bbe619072b05efb55725c9df851363892b77ad6788dfd28eadce6a8f84a8209'
  [4.4.4]='34c316a4a78d7ee9b95d4391530f9bb3ff3edd99ebbebfac6354ed173e940884'
  [5.0.0]='781ac6e21d8e1cf3514ddc6a71418cefde903df241d4e7011e75f90eb62a952e'
)

for rt_version in "${!versions[@]}"; do
  dir=${rt_version:0:3}
  rt_sha=${versions[$rt_version]}

  if [[ "$rt_version" == *"alpha"* ]] || [[ "$rt_version" == *"beta"* ]]; then
    rt_release='devel'
  else
    rt_release='release'
  fi

  mkdir -p "$dir"

  cp -a \
    apache.rt.conf \
    docker-entrypoint.sh \
    RT_SiteConfig.pm \
    "$dir"

  cp -a Dockerfile.template "$dir"/Dockerfile

  sed -i \
    -e "s/%%RT_RELEASE%%/$rt_release/" \
    -e "s/%%RT_SHA%%/$rt_sha/" \
    -e "s/%%RT_VERSION_MAJOR%%/${rt_version:0:1}/" \
    -e "s/%%RT_VERSION%%/$rt_version/" \
    "$dir"/apache.rt.conf "$dir"/docker-entrypoint.sh "$dir"/Dockerfile
done
