#!/bin/bash

set -eo pipefail

if [ "${S3_S3V4}" = "yes" ]; then
    aws configure set default.s3.signature_version s3v4
fi

if [ "${SCHEDULE}" = "**None**" ]; then
  sh backup.sh
else
(
  echo "S3_ACCESS_KEY_ID=$S3_ACCESS_KEY_ID"
  echo "S3_SECRET_ACCESS_KEY=$S3_SECRET_ACCESS_KEY"
  echo "S3_BUCKET=$S3_BUCKET"
  echo "MYSQL_HOST=$MYSQL_HOST"
  echo "MYSQL_USER=$MYSQL_USER"
  echo "MYSQL_PASSWORD=$MYSQL_PASSWORD"
  echo "S3_REGION=$S3_REGION"
  echo "S3_IAMROLE=$S3_IAMROLE"
  echo "AWS_ACCESS_KEY_ID=$S3_ACCESS_KEY_ID"
  echo "AWS_SECRET_ACCESS_KEY=$S3_SECRET_ACCESS_KEY"
  echo "AWS_DEFAULT_REGION=$S3_REGION"
  echo "$SCHEDULE root /bin/bash /backup.sh >> /proc/1/fd/1 2>> /proc/1/fd/2"
) > /etc/cron.d/mycron
  chmod 0644 /etc/cron.d/mycron
  crontab /etc/cron.d/mycron
  exec cron -f
fi
