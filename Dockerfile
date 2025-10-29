# -----------------------------
# Stage 1: Build Angular App
# -----------------------------
FROM node:18 AS build
WORKDIR /app

# Copy package files first for caching
COPY package*.json ./
RUN npm install --legacy-peer-deps

# Copy remaining app files
COPY . .

# 🧹 (Optional) Remove broken CSS sed command — can corrupt CSS
# RUN sed -i 's|url(|/*url(|g' src/app/login/login.component.css

# Build Angular app
RUN npm run build -- --configuration production --optimization=false

# -----------------------------
# Stage 2: Serve with Nginx
# -----------------------------
FROM nginx:alpine

# Copy build output from previous stage
COPY --from=build /app/dist/ /usr/share/nginx/html

# Copy custom nginx config (optional, if exists)
# COPY nginx.conf /etc/nginx/conf.d/default.conf

# Expose port 80
EXPOSE 80

# Run Nginx in foreground
CMD ["nginx", "-g", "daemon off;"]
