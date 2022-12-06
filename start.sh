#!/bin/bash
/usr/local/bin/revad -c /etc/revad/revad.toml -p /run/revad/revad.pid &> /proc/1/fd/1 &
apachectl -D FOREGROUND
