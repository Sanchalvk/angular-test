# Stage 1: Build Angular app
FROM node:18 AS build
WORKDIR /app
COPY package*.json ./
RUN npm install
COPY . .
# Build output goes to dist/my-login-app
RUN npm run build --configuration=production --output-path=dist/my-login-app

# Stage 2: Serve with NGINX
FROM nginx:1.25-alpine

# Copy the Angular app from the correct dist path
COPY --from=build /app/dist/my-login-app /usr/share/nginx/html

# Copy environment template for runtime substitution
COPY src/assets/env.template.js /usr/share/nginx/html/assets/env.template.js

# Inject runtime API_URL and start Nginx
CMD ["/bin/sh", "-c", "envsubst '\\$API_URL' < /usr/share/nginx/html/assets/env.template.js > /usr/share/nginx/html/assets/env.js && exec nginx -g 'daemon off;'"]
