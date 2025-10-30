# Stage 1: Build Angular app
FROM node:18 AS build
WORKDIR /app
COPY package*.json ./
RUN npm install
COPY . .
RUN npm run build --configuration=production --output-path=dist/my-login-app

# Stage 2: Serve with NGINX
FROM nginx:1.25-alpine

# Copy built app
COPY --from=build /app/dist/my-login-app /usr/share/nginx/html/my-login-app

# Copy env template
COPY src/assets/env.template.js /usr/share/nginx/html/my-login-app/assets/env.template.js

# Replace placeholder and start NGINX
CMD ["/bin/sh", "-c", "envsubst '\\$API_URL' < /usr/share/nginx/html/my-login-app/assets/env.template.js > /usr/share/nginx/html/my-login-app/assets/env.js && exec nginx -g 'daemon off;'"]
