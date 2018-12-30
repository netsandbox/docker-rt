#!/bin/bash

set -euo pipefail

declare -A versions=(
  [4.0.25]='69daa9b9e6c9acb4ca31ec1c3efc8bb4901cc7047eed784f2f91515815fdd4cd'
  [4.2.15]='3752a12eff67c640e577d2b5feda01c9f07e3b2e227eabf50089086e98038bba'
  [4.4.3]='738ab43cac902420b3525459e288515d51130d85810659f6c8a7e223c77dadb1'
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
