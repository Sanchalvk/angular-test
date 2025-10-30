# Stage 1: Build Angular app
FROM node:18 AS build
WORKDIR /app
COPY package*.json ./
RUN npm install
COPY . .
RUN npm run build --configuration=production --output-path=dist/angular-test

# Stage 2: Serve with NGINX
FROM nginx:1.25-alpine

# Copy built Angular app
COPY --from=build /app/dist/angular-test /usr/share/nginx/html

# Copy environment template
COPY src/assets/env.template.js /usr/share/nginx/html/assets/env.template.js

# Replace placeholder with runtime environment variable
CMD ["/bin/sh", "-c", "envsubst '\\$API_URL' < /usr/share/nginx/html/assets/env.template.js > /usr/share/nginx/html/assets/env.js && exec nginx -g 'daemon off;'"]
