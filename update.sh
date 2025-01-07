#!/bin/bash

set -Eeuo pipefail

declare -a versions=("4.4.7" "5.0.7" "stable" "master")

for version in "${versions[@]}"; do
  rt_dir=${version%.*}

  mkdir -p "$rt_dir"

  cp Dockerfile.template "${rt_dir}/Dockerfile"
  cp docker-entrypoint.sh RT_SiteConfig.pm "$rt_dir"

  if [[ "$version" =~ ^(master|stable)$ ]]; then
    url="https://github.com/bestpractical/rt/archive/refs/heads/${version}.tar.gz"

    if [[ "$version" == "master" ]]; then
      version_tag="rt-6.0.${version}"
    else
      version_tag="rt-5.0.${version}"
    fi

    sed -i "s!%%RT_VERSION_TAG%%!$version_tag!" "${rt_dir}/Dockerfile"
  else
    if [[ "$version" =~ ^(alpha|beta)$ ]]; then
      url="https://download.bestpractical.com/pub/rt/devel/rt-${version}.tar.gz"
    else
      url="https://download.bestpractical.com/pub/rt/release/rt-${version}.tar.gz"
    fi

    sed -i \
      -e "/%%RT_VERSION_TAG%%/d" \
      -e "/make fixdeps/d" \
      "${rt_dir}/Dockerfile"
  fi

  sed -i "s!%%RT_URL%%!$url!" "${rt_dir}/Dockerfile"
done
