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

# 🔥 Replace API URL in environment.ts before building
ARG API_URL=https://dummyjson.com/auth/login
RUN sed -i "s|apiUrl: '.*'|apiUrl: '${API_URL}'|" src/environments/environment.ts

# Build the Angular app
RUN npm run build -- --configuration production
