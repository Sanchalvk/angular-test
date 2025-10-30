
# Stage 1 - Build Angular App
FROM node:20-alpine AS build

WORKDIR /app
COPY package*.json ./

# 👇 Add this line instead of plain npm install
RUN npm install --legacy-peer-deps

COPY . .
RUN npm run build --prod

# Stage 2 - Serve using Nginx
FROM nginx:alpine
COPY --from=build /app/dist /usr/share/nginx/html
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
