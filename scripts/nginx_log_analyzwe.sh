#! /bin/bash
echo "Top IPs:"
awk '{print $1}' nginx.log | sort | uniq -c | sort -nr | head -5

echo "Top Paths:"
awk -F\" '{print $2}' nginx.log | awk '{print $2}' | sort | uniq -c | sort -nr | head -5

echo "Top Status Codes:"
awk '{print $9}' nginx.log | sort | uniq -c | sort -nr | head -5

echo "Top User Agents:"
awk -F\" '{print $6}' nginx.log | sort | uniq -c | sort -nr | head -5