# ================================
# Stage 1: Build Angular App
# ================================
FROM node:18 AS build
WORKDIR /app

# Copy package files and install dependencies
COPY package*.json ./
RUN npm install

# Copy the entire Angular project
COPY . .

# 🔥 Replace API URL in both environment files before build
ARG API_URL=https://api.example.com/v1/login
RUN sed -i "s|apiUrl: '.*'|apiUrl: '${API_URL}'|" src/app/environments/environment.ts && \
    sed -i "s|apiUrl: '.*'|apiUrl: '${API_URL}'|" src/app/environments/environment.prod.ts

# Build Angular for production
RUN npm run build -- --configuration production

# ================================
# Stage 2: Serve with Nginx
# ================================
FROM nginx:alpine
COPY --from=build /app/dist/my-login-app /usr/share/nginx/html
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
