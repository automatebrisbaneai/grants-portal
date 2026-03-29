FROM nginx:alpine

COPY index.html grants.json /usr/share/nginx/html/

# Write config.js from env var at container startup
# OPENROUTER_KEY is set in Coolify environment variables
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

EXPOSE 80
ENTRYPOINT ["/entrypoint.sh"]
