#!/bin/bash
bash /metrics.sh &
mkdir -p /var/tmp/reva
/usr/local/bin/revad -c /etc/revad/revad.toml -p /run/revad/revad.pid
