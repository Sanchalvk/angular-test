# Stage 1 — build Angular
FROM node:18 AS build
WORKDIR /app
COPY package*.json ./
RUN npm install
COPY . .
RUN npm run build --configuration=production --output-path=dist/my-login-app

# Stage 2 — nginx to serve files
FROM nginx:1.25-alpine
# install envsubst
RUN apk add --no-cache gettext

# copy built app (Angular output under dist/<project>)
COPY --from=build /app/dist/my-login-app /usr/share/nginx/html/my-login-app

# ensure template exists inside image
COPY src/assets/env.template.js /usr/share/nginx/html/my-login-app/assets/env.template.js

# entrypoint script will generate env.js at container start
COPY docker-entrypoint.sh /docker-entrypoint.sh
RUN chmod +x /docker-entrypoint.sh

EXPOSE 80
ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["nginx", "-g", "daemon off;"]
