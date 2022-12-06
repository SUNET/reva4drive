#!/bin/bash
mkdir /var/tmp/reva/
touch /var/tmp/reva/ocm-invites.json
/usr/local/bin/revad -c /etc/revad/revad.toml -p /run/revad/revad.pid &> /proc/1/fd/1 &
apachectl -D FOREGROUND
