#!/bin/bash

set -Eeuo pipefail

declare -A versions=(
  [4.2.16]='1bbe619072b05efb55725c9df851363892b77ad6788dfd28eadce6a8f84a8209'
  [4.4.4]='34c316a4a78d7ee9b95d4391530f9bb3ff3edd99ebbebfac6354ed173e940884'
  [5.0.1]='6c181cc592c48a2cba8b8df1d45fda0938d70f84ceeba1afc436f16a6090f556'
)

for version in "${!versions[@]}"; do
  version_major_minor=${version%.*}

  mkdir -p "$version_major_minor"

  cp apache.rt.conf docker-entrypoint.sh RT_SiteConfig.pm "$version_major_minor"
  cp Dockerfile.template "$version_major_minor"/Dockerfile

  if [[ "$version_major_minor" == '4.2' ]]; then
    # RT 4.2 does not support --enable-externalauth
    sed -i '/--enable-externalauth/d' "$version_major_minor"/Dockerfile
  fi

  if [[ "$version" == *"alpha"* ]] || [[ "$version" == *"beta"* ]]; then
    release='devel'
  else
    release='release'
  fi

  sed -i \
    -e "s/%%RT_RELEASE%%/$release/" \
    -e "s/%%RT_SHA%%/${versions[$version]}/" \
    -e "s/%%RT_VERSION_MAJOR%%/${version%%.*}/" \
    -e "s/%%RT_VERSION%%/$version/" \
    "$version_major_minor"/apache.rt.conf "$version_major_minor"/docker-entrypoint.sh "$version_major_minor"/Dockerfile
done
