#!/bin/bash

# We start this script from start.sh
# We loop for ever, but we only check stats twiche per day.
# It only updates once per day anyway
metrics_file="/etc/revad/metrics.json"
tmp_file="/tmp/metrics.json"
while true; do
  rclone cat \
    --no-check-certificate \
    --webdav-headers 'Host,sunet.drive.sunet.se' \
    --use-cookies 'statistics:drive-storage-report/billing/latest.csv' | \
    awk -F ';' \
    '{storage+=$2;users+=$3;} END{print "{\n\t\"cs3_org_sciencemesh_site_total_num_users\": "users",\n\t\"cs3_org_sciencemesh_site_total_amount_storage\": "storage * 1024 * 1024 * 1024",\n\t\"cs3_org_sciencemesh_site_total_num_groups\": 0\n}"}' \
    > ${tmp_file}
  if [[ $(jq -r .cs3_org_sciencemesh_site_total_amount_storage "${tmp_file}") != 0 ]]; then
    mv "${tmp_file}" "${metrics_file}"
  fi

  sleep 12h
done
