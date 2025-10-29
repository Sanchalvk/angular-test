FROM nginx:alpine

# Copy built Angular app
COPY --from=build /app/dist/ /usr/share/nginx/html

# Copy environment template
COPY src/assets/env.template.js /usr/share/nginx/html/assets/env.template.js

# Install envsubst for runtime environment substitution
RUN apk add --no-cache gettext

# Create entrypoint script for runtime env replacement
RUN echo '#!/bin/sh\n\
: "${API_URL:=https://api.mybackend.com/v1/login}"\n\
envsubst < /usr/share/nginx/html/assets/env.template.js > /usr/share/nginx/html/assets/env.js\n\
exec nginx -g "daemon off;"' > /entrypoint.sh && chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
EXPOSE 80
