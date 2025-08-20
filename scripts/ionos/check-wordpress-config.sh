#!/bin/bash

# WordPress Configuration Check Script
# Run this on IONOS to verify WordPress setup

set -e

echo "🔍 Checking WordPress configuration..."

# Check if we're in the right directory
if [ ! -f "wp-config.php" ]; then
    echo "❌ wp-config.php not found!"
    exit 1
fi

echo "✅ wp-config.php found"

# Check database connection
echo "🔌 Testing database connection..."
if php -r "
require_once 'wp-config.php';
try {
    \$mysqli = new mysqli(DB_HOST, DB_USER, DB_PASSWORD, DB_NAME);
    if (\$mysqli->connect_error) {
        throw new Exception('Connection failed: ' . \$mysqli->connect_error);
    }
    echo '✅ Database connection successful\n';
    echo 'Database: ' . DB_NAME . '\n';
    echo 'Host: ' . DB_HOST . '\n';
    \$mysqli->close();
} catch (Exception \$e) {
    echo '❌ Database connection failed: ' . \$e->getMessage() . '\n';
    exit(1);
}
"; then
    echo "✅ Database connection test passed"
else
    echo "❌ Database connection test failed"
    exit 1
fi

# Check file permissions
echo "🔐 Checking file permissions..."
if [ -r "wp-config.php" ]; then
    echo "✅ wp-config.php is readable"
else
    echo "❌ wp-config.php is not readable"
fi

if [ -r ".htaccess" ]; then
    echo "✅ .htaccess is readable"
else
    echo "❌ .htaccess is not readable"
fi

# Check wp-content structure
echo "📁 Checking wp-content structure..."
if [ -d "wp-content/themes" ]; then
    echo "✅ wp-content/themes directory exists"
    if [ -d "wp-content/themes/my-theme" ]; then
        echo "✅ my-theme directory exists"
    else
        echo "❌ my-theme directory not found"
    fi
else
    echo "❌ wp-content/themes directory not found"
fi

if [ -d "wp-content/uploads" ]; then
    echo "✅ wp-content/uploads directory exists"
else
    echo "❌ wp-content/uploads directory not found"
fi

echo ""
echo "🎉 WordPress configuration check completed!"
echo ""
echo "📋 Next steps:"
echo "1. Visit $WEBSITE_URL to complete WordPress installation"
echo "2. Activate my-theme in WordPress admin"
echo "3. Configure site settings"
echo "4. Create content"
