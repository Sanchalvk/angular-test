# ================================
# Stage 1: Build Angular
# ================================
FROM node:18 AS build
WORKDIR /app

# Copy package files and install dependencies
COPY package*.json ./
RUN npm install

# Copy the entire Angular project
COPY . .

# 🔥 Accept API_URL argument and replace in environment files
ARG API_URL=https://api.example.com/v1/login
RUN echo "🔧 Replacing API URL with ${API_URL}" && \
    sed -i "s|apiUrl: '.*'|apiUrl: '${API_URL}'|" src/environments/environment.ts && \
    sed -i "s|apiUrl: '.*'|apiUrl: '${API_URL}'|" src/environments/environment.prod.ts

# Build Angular for production
RUN npm run build -- --configuration production

# ================================
# Stage 2: Serve with Nginx
# ================================
FROM nginx:alpine
COPY --from=build /app/dist/my-login-app /usr/share/nginx/html
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
