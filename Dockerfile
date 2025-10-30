# ================================
# Stage 1: Build Angular
# ================================
FROM node:18 AS build
WORKDIR /app

# Install dependencies
COPY package*.json ./
RUN npm install

# Copy the whole app
COPY . .

# Build Angular for production
RUN npm run build --configuration production --output-path=dist/my-login-app

# ================================
# Stage 2: Serve with NGINX
# ================================
FROM nginx:1.25-alpine

# Copy built app from builder
COPY --from=build /app/dist/my-login-app /usr/share/nginx/html

# Copy the env template file into assets folder
COPY src/assets/env.template.js /usr/share/nginx/html/assets/env.template.js

# Install envsubst (used for replacing $API_URL)
RUN apk add --no-cache gettext

# On container start: replace placeholder with real value
CMD ["/bin/sh", "-c", "envsubst < /usr/share/nginx/html/assets/env.template.js > /usr/share/nginx/html/assets/env.js && nginx -g 'daemon off;'"]
