# Copy built Angular app
COPY dist/my-login-app /usr/share/nginx/html/my-login-app

# Copy template file and create env.js dynamically at container startup
COPY docker-entrypoint.sh /docker-entrypoint.sh
RUN chmod +x /docker-entrypoint.sh

ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["nginx", "-g", "daemon off;"]
