#!/bin/bash

DATE=$(date +%F-%H-%M)
CONTAINER=mongo

# =========================
# 🔷 CONFIG (ADJUST HERE)
# =========================

LOCAL_RETENTION=3
S3_RETENTION=2

BACKUP_DIR=/tmp/mongo-backup-$DATE
ARCHIVE=/tmp/mongo-backup-$DATE.tar.gz

s3name="mongodb-backup-ibra"

# Step 1: Dump inside container
docker exec $CONTAINER mongodump --out=$BACKUP_DIR

# Step 2: Compress inside container
docker exec $CONTAINER tar -czf $ARCHIVE -C /tmp mongo-backup-$DATE

# Step 3: Copy to host
docker cp $CONTAINER:$ARCHIVE .

# Step 4: Cleanup inside container
docker exec $CONTAINER rm -rf $BACKUP_DIR $ARCHIVE

echo "MongoDB container backup completed successfully"

uploded_file=$(ls -lt | awk '/mongo-backup/ {print $9}' | head -n 1)

aws s3 cp $uploded_file s3://$s3name/

echo "MongoDB container backup upload to S3 completed"

# =========================
# 🔷 Local Retention (dynamic)
# =========================


echo " Applying local retention policy (keep last $LOCAL_RETENTION)..."

ls -t mongo-backup-*.tar.gz | tail -n +$((LOCAL_RETENTION + 1)) | xargs -r rm

echo " Local retention done"

# =========================
# 🔷 S3 Retention (dynamic)
# =========================

echo " Applying S3 retention policy (keep last $S3_RETENTION)..."

aws s3 ls s3://$s3name/ | sort | head -n -$S3_RETENTION | awk '{print $4}' | while read file; do
  aws s3 rm s3://$s3name/$file
done

echo " S3 retention done"
