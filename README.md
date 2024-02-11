# Docker images for RT

[![GitHub Super-Linter](https://github.com/netsandbox/docker-rt/workflows/Lint%20Code%20Base/badge.svg)](https://github.com/marketplace/actions/super-linter)
[![Build and Push Docker Image](https://github.com/netsandbox/docker-rt/actions/workflows/build.yml/badge.svg)](https://github.com/netsandbox/docker-rt/actions/workflows/build.yml)

## Supported tags and respective `Dockerfile` links

- [`4.4` (4.4/*Dockerfile*)](https://github.com/cloos/docker-rt/blob/main/4.4/Dockerfile)
- [`5.0`, `latest` (5.0/*Dockerfile*)](https://github.com/cloos/docker-rt/blob/main/5.0/Dockerfile)

## Where is this image available?

### Docker Hub

![Docker Stars](https://img.shields.io/docker/stars/netsandbox/request-tracker.svg)
![Docker Pulls](https://img.shields.io/docker/pulls/netsandbox/request-tracker.svg)
![Docker Image Size](https://img.shields.io/docker/image-size/netsandbox/request-tracker/latest.svg)

<https://hub.docker.com/r/netsandbox/request-tracker>

The images are signed with [cosign](https://github.com/sigstore/cosign).
To verrify the signature run:

```shell
cosign verify \
  --certificate-identity-regexp https://github.com/netsandbox/docker-rt/ \
  --certificate-oidc-issuer https://token.actions.githubusercontent.com \
  netsandbox/request-tracker:latest \
  netsandbox/request-tracker:5.0 \
  netsandbox/request-tracker:4.4
```

### GitHub Container Registry

<https://github.com/users/netsandbox/packages/container/package/request-tracker>

The images are signed with [cosign](https://github.com/sigstore/cosign).
To verrify the signature run:

```shell
cosign verify \
  --certificate-identity-regexp https://github.com/netsandbox/docker-rt/ \
  --certificate-oidc-issuer https://token.actions.githubusercontent.com \
  ghcr.io/netsandbox/request-tracker:latest \
  ghcr.io/netsandbox/request-tracker:5.0 \
  ghcr.io/netsandbox/request-tracker:4.4
```

## What is Request Tracker?

Request Tracker (RT) is an open source issue tracking system.

<https://bestpractical.com/request-tracker>

## How to use these Docker images

**These images are intended for development or testing, not for production use!**

```shell
# Docker Hub images
docker run -d --name rt -p 80:80 netsandbox/request-tracker:5.0

# GitHub Container Registry images
docker run -d --name rt -p 80:80 ghcr.io/netsandbox/request-tracker:5.0
```

Then, access it via `http://localhost` or `http://host-ip` in a browser.

If you want to run RT on a different port than the default one (80), change the `-p` option and set the `RT_WEB_PORT` environment variable like this:

```shell
# Docker Hub images
docker run -d --name rt -p 8080:8080 -e RT_WEB_PORT=8080 netsandbox/request-tracker:5.0

# GitHub Container Registry images
docker run -d --name rt -p 8080:8080 -e RT_WEB_PORT=8080 ghcr.io/netsandbox/request-tracker:5.0
```

Then, access it via `http://localhost:8080` or `http://host-ip:8080` in a browser.

### Environment Variables

| Environment Variable | Description |
| --- | --- |
| `RT_ROOT_PASSWORD` | RT root user password |
| `RT_WEB_PORT` | RT [WebPort](https://docs.bestpractical.com/rt/latest/RT_Config.html#WebPort) |

## RT Extension Testing

You can use these Docker images to test your RT Extensions.

### GitHub Actions

For [GitHub Actions](https://docs.github.com/actions) add a `.github/workflows/rt-extension-test.yml` file to your
project with this content:

```yaml
name: RT extension test

on:
  pull_request:
  push:

jobs:
  test:
    name: Test RT

    runs-on: ubuntu-latest

    strategy:
      fail-fast: false
      matrix:
        rt:
          - '4.4'
          - '5.0'

    container: ghcr.io/netsandbox/request-tracker:${{ matrix.rt }}

    steps:
      - name: Checkout code
        uses: actions/checkout@v2

      - name: RT extension test
        run: |
          RELEASE_TESTING=1 perl Makefile.PL
          make
          make test
```

### Travis

For [Travis CI](https://www.travis-ci.com/) add a `.travis.yml` file to your
project with this content:

```yaml
language: bash
services: docker

env:
  - RT_VERSION=4.4
  - RT_VERSION=5.0

before_install:
  - env | sort
  - image="netsandbox/request-tracker:$RT_VERSION"

install:
    - docker pull $image
    - docker run -d -v $TRAVIS_BUILD_DIR:/rtx --name rt $image
    - docker ps

script:
    - docker exec rt bash -c "cd /rtx && RELEASE_TESTING=1 perl Makefile.PL && make && make test"
```
