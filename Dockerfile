
# Stage 1: Build Angular app
FROM node:18 AS build
WORKDIR /app

# Copy package files and install dependencies
COPY package*.json ./
RUN npm install

# Copy source code and build Angular app
COPY . .
RUN npm run build -- --configuration production

# Stage 2: Serve built app with Nginx
FROM nginx:alpine

# Copy built app from previous stage
COPY --from=build /app/dist/ /usr/share/nginx/html

# Copy environment template
COPY src/assets/env.template.js /usr/share/nginx/html/assets/env.template.js

# Install gettext for envsubst
RUN apk add --no-cache gettext

# Create entrypoint for dynamic environment replacement
RUN echo '#!/bin/sh\n\
: "${API_URL:=https://api.mybackend.com/v1/login}"\n\
envsubst < /usr/share/nginx/html/assets/env.template.js > /usr/share/nginx/html/assets/env.js\n\
exec nginx -g "daemon off;"' > /entrypoint.sh && chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
EXPOSE 80
