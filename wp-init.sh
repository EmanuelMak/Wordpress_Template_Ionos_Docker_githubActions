#!/bin/bash
set -e

MAX_RETRIES=10
RETRIES=0
WP_PATH=/var/www/html

echo "📡 Checking for WordPress core..."

if [ ! -f "$WP_PATH/wp-settings.php" ]; then
  echo "⬇️ WordPress core not found — downloading..."
  wp core download --path="$WP_PATH" --version=6.7.2 --locale=de_DE --allow-root
fi

echo "📄 Ensuring wp-config.php exists..."
bash /usr/local/bin/wp-config-create.sh


echo "📄 Dumping wp-config.php content:"
cat "$WP_PATH/wp-config.php"

echo "🌐 DNS resolution check:"
getent hosts db || echo "❌ Failed to resolve 'db'"

bash /usr/local/bin/wait-for-db.sh || exit 1

echo "📡 Waiting for database to be ready..."
while ! wp db check --path="$WP_PATH" --allow-root > /dev/null 2>&1; do
  echo "❌ DB not ready, retrying... ($RETRIES/$MAX_RETRIES)"
  sleep 2
  RETRIES=$((RETRIES + 1))
  if [ "$RETRIES" -ge "$MAX_RETRIES" ]; then
    echo "❌ Timeout waiting for DB. Dumping debug info..."
    wp config list --path="$WP_PATH" --allow-root || echo "⚠️ Failed to read wp-config"
    exit 1
  fi
done

echo "✅ DB is ready!"

if ! wp core is-installed --path="$WP_PATH" --allow-root; then
  echo "🚀 Installing WordPress..."
  wp core install \
    --path="$WP_PATH" \
    --url="${WP_URL}" \
    --title="${WORDPRESS_TITLE}" \
    --admin_user="${WORDPRESS_ADMIN_USER}" \
    --admin_password="${WORDPRESS_ADMIN_PASSWORD}" \
    --admin_email="${WORDPRESS_ADMIN_EMAIL}" \
    --skip-email \
    --allow-root
else
  echo "✅ WordPress is already installed."
fi

# Activate custom theme if it exists
if wp theme is-installed my-theme --path="$WP_PATH" --allow-root; then
  echo "🎨 Activating custom theme..."
  wp theme activate my-theme --path="$WP_PATH" --allow-root
else
  echo "⚠️ Custom theme not found, keeping default theme."
fi

echo "🟢 Starting Apache..."
exec apache2-foreground
