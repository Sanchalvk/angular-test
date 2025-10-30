# Stage 1: Build Angular app
FROM node:18 AS build
WORKDIR /app
COPY package*.json ./
RUN npm install
COPY . .
RUN npm run build --configuration=production

# Stage 2: Serve with NGINX
FROM nginx:1.25-alpine

# Copy built Angular files
COPY --from=build /app/dist /usr/share/nginx/html

# Copy env template
COPY src/assets/env.template.js /usr/share/nginx/html/assets/env.template.js

# On container startup, replace $API_URL and generate env.js
CMD ["/bin/sh", "-c", "envsubst '\\$API_URL' < /usr/share/nginx/html/assets/env.template.js > /usr/share/nginx/html/assets/env.js && exec nginx -g 'daemon off;'"]
