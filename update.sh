#!/bin/bash

set -euo pipefail

declare -A versions=(
  [4.0.25]='69daa9b9e6c9acb4ca31ec1c3efc8bb4901cc7047eed784f2f91515815fdd4cd'
  [4.2.16]='1bbe619072b05efb55725c9df851363892b77ad6788dfd28eadce6a8f84a8209'
  [4.4.4]='34c316a4a78d7ee9b95d4391530f9bb3ff3edd99ebbebfac6354ed173e940884'
)
travis_env=
for rt_version in "${!versions[@]}"; do
  rt_sha=${versions[$rt_version]}
  dir=${rt_version:0:3}
  travis_env+="\n  - VERSION=$dir"

  if [ "$dir" = '4.0' ]; then
    rt_configure='--disable-gpg --enable-gd --enable-graphviz --with-db-type=SQLite --with-devel-mode \\'
  else
    rt_configure='--disable-gpg --disable-smime --enable-developer --enable-gd --enable-graphviz --with-db-type=SQLite \\'
  fi

  mkdir -p $dir

  cp -a \
    apache.rt.conf \
    docker-entrypoint.sh \
    RT_SiteConfig.pm \
    $dir

  cp -a Dockerfile.template $dir/Dockerfile

  sed -i \
    -e "s/%%RT_VERSION%%/$rt_version/" \
    -e "s/%%RT_SHA%%/$rt_sha/" \
    -e "s/%%RT_CONFIGURE%%/$rt_configure/" \
    $dir/Dockerfile
done

travis_env=$(echo -e "$travis_env" | sort | sed ':a;N;$!ba;s/\n/\\n/g')
travis="$(awk -v 'RS=\n\n' '$1 == "env:" { $0 = "env:'"$travis_env"'" } { printf "%s%s", $0, RS }' .travis.yml)"
echo "$travis" > .travis.yml
