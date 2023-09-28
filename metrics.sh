#!/bin/bash

# We start this script from start.sh
# We loop for ever, and when we hit 3 AM we report the statistics, otherwise we sleep
while true; do
  hour="$(date +%H)"
  date=$(date +%Y%m%d)
  if [[ "${hour}" == "00" ]] || [[ "${hour}" == "01" ]] || [[ "${hour}" == "02" ]]; then
    date=$(date +%Y%m%d -d yesterday)
  fi
  rclone cat \
    --no-check-certificate \
    --webdav-headers "Host,sunet.drive.sunet.se" \
    --use-cookies "statistics:drive-storage-report/billing/daily/billing-${date}.csv" | \
    awk -F ';' \
    '{storage+=$2;users+=$3;} END{print "{\n\t\"cs3_org_sciencemesh_site_total_num_users\": "users",\n\t\"cs3_org_sciencemesh_site_total_amount_storage\": "storage * 1024 * 1024 * 1024",\n\t\"cs3_org_sciencemesh_site_total_num_groups\": 0\n}"}' \
    > /etc/revad/metrics.json
  sleep 12h
done
