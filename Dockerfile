# ================================
# Stage 1 - Build Angular App
# ================================
FROM node:20-alpine AS build

WORKDIR /app
COPY package*.json ./
RUN npm install --legacy-peer-deps
COPY . .
RUN npm run build --prod

# ================================
# Stage 2 - Serve using Nginx
# ================================
FROM nginx:alpine

# Copy built Angular app
COPY --from=build /app/dist /usr/share/nginx/html

# Copy env template
COPY src/assets/env.template.js /usr/share/nginx/html/assets/env.template.js

# Replace $API_URL in env.template.js at runtime
CMD sh -c "envsubst '\$API_URL' < /usr/share/nginx/html/assets/env.template.js > /usr/share/nginx/html/assets/env.js && exec nginx -g 'daemon off;'"

EXPOSE 80
