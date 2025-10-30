# Stage 1: Build Angular app
FROM node:18 AS build

WORKDIR /app

# Copy package files and install dependencies
COPY package*.json ./
RUN npm install

# Copy the rest of the source code
COPY . .

# Build the Angular app for production
RUN npm run build --configuration=production --output-path=dist/my-login-app

# ================================
# Stage 2: Serve with NGINX
# ================================
FROM nginx:1.25-alpine

# Copy built Angular app from the build stage
COPY --from=build /app/dist/my-login-app /usr/share/nginx/html

# Copy environment template
COPY src/assets/env.template.js /usr/share/nginx/html/assets/env.template.js

# Replace placeholder variable at container startup
CMD ["/bin/sh", "-c", "envsubst '\\$API_URL' < /usr/share/nginx/html/assets/env.template.js > /usr/share/nginx/html/assets/env.js && exec nginx -g 'daemon off;'"]
