#!/bin/bash

set -Eeuo pipefail

declare -A versions=(
  [4.4.7]='47af1651d5df3f25b6374ff6c1da71c66202d61919d9431c17259fa3df69ae59'
  [5.0.7]='1a1a4838979f08c58e67642686e4fd980e1f4ee98e144ff8a56f870f37162cce'
)

for version in "${!versions[@]}"; do
  version_major_minor=${version%.*}

  mkdir -p "$version_major_minor"

  cp docker-entrypoint.sh RT_SiteConfig.pm "$version_major_minor"
  cp Dockerfile.template "$version_major_minor"/Dockerfile

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
    "$version_major_minor"/docker-entrypoint.sh "$version_major_minor"/Dockerfile
done
