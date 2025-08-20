#!/bin/bash
set -e

WP_PATH=/var/www/html

echo "📄 Checking for wp-config.php..."

if [ -f "$WP_PATH/wp-config.php" ]; then
  echo "✅ wp-config.php already exists, skipping."
else
  echo "⚙️ Creating wp-config.php..."
  wp config create \
    --path="$WP_PATH" \
    --dbname="$WORDPRESS_DB_NAME" \
    --dbuser="$WORDPRESS_DB_USER" \
    --dbpass="$WORDPRESS_DB_PASSWORD" \
    --dbhost="$WORDPRESS_DB_HOST" \
    --skip-check \
    --allow-root
  echo "✅ wp-config.php created."
fi
