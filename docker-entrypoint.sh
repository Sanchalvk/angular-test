#!/bin/sh
set -e

# default fallback if API_URL not set in compose
API_URL=${API_URL:-"http://localhost:8081/v1"}

echo ">>> Generating env.js with API_URL=$API_URL"

# if template exists, generate env.js; else leave existing env.js
TEMPLATE="/usr/share/nginx/html/my-login-app/assets/env.template.js"
TARGET="/usr/share/nginx/html/my-login-app/assets/env.template.js"

if [ -f "$TEMPLATE" ]; then
  envsubst '$API_URL' < "$TEMPLATE" > "$TARGET"
else
  echo "No env.template.js found at $TEMPLATE — leaving env.js unchanged if present"
fi

exec "$@"
