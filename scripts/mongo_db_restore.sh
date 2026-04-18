#!/bin/bash

set -e

CONTAINER="mongo"
BUCKET="mongodb-backup-ibra"
WORKDIR="/tmp/mongo-restore"

mkdir -p $WORKDIR
cd $WORKDIR

echo "Getting latest backup from S3..."

# Get latest backup file
LATEST_FILE=$(aws s3 ls s3://$BUCKET/ | sort | tail -n 1 | awk '{print $4}')

if [ -z "$LATEST_FILE" ]; then
  echo " No backup found in S3"
  exit 1
fi

echo " Latest backup: $LATEST_FILE"

# Download
aws s3 cp s3://$BUCKET/$LATEST_FILE .

# Extract
tar -xzf $LATEST_FILE

# Get extracted folder name
EXTRACTED_DIR=$(tar -tzf $LATEST_FILE | head -n 1 | cut -d "/" -f1)

echo " Restoring from: $EXTRACTED_DIR"

# Copy into container
docker cp $EXTRACTED_DIR $CONTAINER:/tmp/

# Restore (clean overwrite)
docker exec $CONTAINER mongorestore --drop /tmp/$EXTRACTED_DIR

echo " Restore completed"

# Cleanup working directory
cd /
rm -rf $WORKDIR

echo " Local temp cleanup done"
