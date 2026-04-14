#!/bin/bash
set -euo pipefail

DOMAIN=$1
MAX_RETRIES=30
RETRY_INTERVAL=10

echo "🔍 Health check for $DOMAIN"

for i in $(seq 1 $MAX_RETRIES); do
  HTTP_CODE=$(curl -s -o /dev/null -w "%{http_code}" "https://$DOMAIN/health")
  
  if [ "$HTTP_CODE" -eq 200 ]; then
    echo "✅ Service is healthy (HTTP $HTTP_CODE)"
    exit 0
  fi
  
  echo "Attempt $i/$MAX_RETRIES: Service returned HTTP $HTTP_CODE"
  sleep $RETRY_INTERVAL
done

echo "❌ Health check failed after $MAX_RETRIES attempts"
exit 1