# wait-for-db.sh
#!/bin/bash

echo "⏳ Waiting for MySQL to be ready at $WORDPRESS_DB_HOST..."

for i in {1..15}; do
  if mysqladmin ping -h"$WORDPRESS_DB_HOST" -u"$WORDPRESS_DB_USER" -p"$WORDPRESS_DB_PASSWORD" --silent; then
    echo "✅ MySQL is up!"
    exit 0
  fi
  echo "❌ MySQL not ready yet ($i/15)..."
  sleep 2
done

echo "❌ Timeout: MySQL did not respond."
exit 1