#!/bin/bash

set -Eeuo pipefail

declare -a versions=("4.4.7" "5.0.7")

for version in "${versions[@]}"; do
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
    -e "s/%%RT_VERSION_MAJOR%%/${version%%.*}/" \
    -e "s/%%RT_VERSION%%/$version/" \
    "$version_major_minor"/docker-entrypoint.sh "$version_major_minor"/Dockerfile
done
