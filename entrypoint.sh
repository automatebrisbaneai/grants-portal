#!/bin/sh
# Write config.js from environment variable at container startup
# This keeps the API key out of the git repo

cat > /usr/share/nginx/html/config.js << EOF
window.GRANTS_CONFIG = {
  apiKey: '${OPENROUTER_KEY}',
  apiUrl: 'https://openrouter.ai/api/v1/chat/completions',
  models: {
    writing: 'anthropic/claude-sonnet-4',
    chat: 'google/gemini-3.1-flash-lite-preview',
    backend: 'google/gemini-3.1-flash-lite-preview'
  }
};
EOF

# Start nginx
exec nginx -g 'daemon off;'
