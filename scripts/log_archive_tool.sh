#!/bin/bash

set -euo pipefail

logs_dir="$1"
archive_dir="$logs_dir/archive"
retention_days=7  #change this for your adjustment
s3_bucket="s3://your-bucket-name/logs"   #CHANGE THIS

# 1. Validate arguments
if [ $# -ne 1 ]; then
    echo "Usage: $0 <logs_directory>"
    exit 1
fi

# 2. Validate directory
if [ ! -d "$logs_dir" ]; then
    echo "Invalid directory"
    exit 1
fi

# 3. Ensure archive directory exists
mkdir -p "$archive_dir"

# 4. Generate archive name (date-based)
archive_file="$archive_dir/logs_$(date +%F).tar.gz"

echo "Starting log archival at $(date)"

# 5. Find old logs and archive them (batch mode - efficient)
files=$(find "$logs_dir" -type f -name "*.log" -mtime +"$retention_days" ! -path "$archive_dir/*")

if [ -z "$files" ]; then
    echo "No files to archive."
    exit 0
fi

# 6. Create archive (safe)
echo "Creating archive: $archive_file"
tar -czf "$archive_file" $files

# 7. Upload to S3
echo "Uploading to S3: $s3_bucket"
aws s3 cp "$archive_file" "$s3_bucket/"

# 8. Verify upload success
if [ $? -eq 0 ]; then
    echo "Upload successful. Removing original files..."

    # 9. Delete original logs ONLY after successful upload
    echo "$files" | xargs rm -f

    echo "Cleanup completed."
else
    echo "Upload failed. Keeping files for safety."
    exit 1
fi

echo "Log archival completed successfully at $(date)"