#!/bin/sh

# Replace placeholder in env.template.js
echo "🔧 Replacing API_URL with: $API_URL"
sed -i "s|\$API_URL|${API_URL:-http://localhost:8081/v1}|g" /usr/share/nginx/html/assets/env.template.js

exec "$@"
