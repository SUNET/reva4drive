#!/bin/bash
mkdir -p /var/tmp/reva
touch /var/tmp/reva/ocm-invites.json
/usr/local/bin/revad -c /etc/revad/revad.toml -p /run/revad/revad.pid
