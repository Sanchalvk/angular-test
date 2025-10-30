# ---------- Stage 1: Build Angular App ----------
FROM node:18 AS build
WORKDIR /app

COPY package*.json ./
RUN npm install
COPY . .
RUN npm run build --configuration=production --output-path=dist/my-login-app


# ---------- Stage 2: Serve with NGINX ----------
FROM nginx:1.25-alpine
RUN apk add --no-cache gettext

COPY --from=build /app/dist/my-login-app /usr/share/nginx/html/my-login-app
COPY src/assets/env.template.js /usr/share/nginx/html/my-login-app/assets/env.template.js

COPY docker-entrypoint.sh /docker-entrypoint.sh
RUN chmod +x /docker-entrypoint.sh

EXPOSE 80
ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["nginx", "-g", "daemon off;"]
