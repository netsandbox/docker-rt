[![Travis CI](https://img.shields.io/travis/cloos/docker-rt/master.svg)](https://travis-ci.org/cloos/docker-rt/branches)
# Supported tags and respective `Dockerfile` links

-	[`4.2`, `latest` (4.2/*Dockerfile*)](https://github.com/cloos/docker-rt/blob/master/4.2/Dockerfile)

# What is Request Tracker?

Request Tracker (RT) is an open source issue tracking system.

> https://www.bestpractical.com/rt/

# How to use this image

**This image is intended for development or testing, not for production use.**

```console
$ docker run -it --rm --name rt -p 8080:80 netsandbox/request-tracker
```

Then, access it via `http://localhost:8080` or `http://host-ip:8080` in a browser.
