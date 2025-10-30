# ================================
# Stage 2: Serve with NGINX
# ================================
FROM nginx:alpine

# Copy built Angular app from previous stage
COPY --from=build /app/dist/ /usr/share/nginx/html/

# Copy environment template
COPY src/assets/env.template.js /usr/share/nginx/html/assets/env.template.js

# Install gettext for envsubst
RUN apk add --no-cache gettext

# Create entrypoint script (escaped heredoc to prevent Dockerfile parsing)
RUN cat <<-'EOF' > /entrypoint.sh
#!/bin/sh
# Default environment variable (can be overridden at runtime)
: "${API_URL:=https://api.mybackend.com/v1/login}"

# Replace template variables in env.template.js
envsubst < /usr/share/nginx/html/assets/env.template.js > /usr/share/nginx/html/assets/env.js

# Start NGINX
exec nginx -g "daemon off;"
EOF

RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
EXPOSE 80
