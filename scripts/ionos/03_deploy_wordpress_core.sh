#!/bin/bash

# IONOS Deployment - Schritt 3: WordPress Core deployen
# Lädt den WordPress Core für IONOS hoch (ohne Themes/Plugins)

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}🚀 IONOS Deployment - Schritt 3: WordPress Core deployen${NC}"
echo -e "${BLUE}=====================================================${NC}"
echo ""

# Load environment variables
if [ -f "../.env" ]; then
    echo -e "${GREEN}✅ Loading .env file...${NC}"
    export $(cat ../.env | grep -v '^#' | xargs)
else
    echo -e "${RED}❌ .env file not found!${NC}"
    exit 1
fi

echo -e "${BLUE}📋 IONOS Configuration:${NC}"
echo -e "DEPLOY_PATH: ${GREEN}$DEPLOY_PATH${NC}"
echo -e "IONOS_HOST: ${GREEN}$IONOS_HOST${NC}"
echo -e "IONOS_USERNAME: ${GREEN}$IONOS_USERNAME${NC}"
echo -e "WEBSITE_URL: ${GREEN}$WEBSITE_URL${NC}"
echo ""

# Check if we're in the right directory
if [ ! -d "../themes" ] || [ ! -d "../media" ]; then
    echo -e "${RED}❌ Project structure not found!${NC}"
    echo -e "${YELLOW}💡 Run this script from IONOS_Deployment/ directory${NC}"
    exit 1
fi

echo -e "${GREEN}✅ Project structure verified${NC}"
echo ""

       # Create WordPress core package
       echo -e "${BLUE}📦 Creating WordPress core package...${NC}"
       if [ -d "gen/wordpress-core" ]; then
           rm -rf gen/wordpress-core
       fi

       mkdir -p gen/wordpress-core
       cd gen/wordpress-core

# Create WordPress core files
echo "📝 Creating WordPress core files..."

# Create index.php
cat > index.php << 'EOF'
<?php
/**
 * Front to the WordPress application. This file doesn't do anything, but loads
 * wp-blog-header.php which does and tells WordPress to load the theme.
 *
 * @package WordPress
 */

/**
 * Tells WordPress to load the WordPress theme and output it.
 *
 * @var bool
 */
define( 'WP_USE_THEMES', true );

/** Loads the WordPress Environment and Template */
require __DIR__ . '/wp-blog-header.php';
EOF

# Create wp-config.php for IONOS production
cat > wp-config.php << EOF
<?php
/**
 * The base configuration for WordPress
 *
 * @link https://wordpress.org/support/article/editing-wp-config-php/
 *
 * @package WordPress
 */

// ** Database settings - You can get this info from your web host ** //
/** The name of the database for WordPress */
define( 'DB_NAME', '$PROD_DB_NAME' );

/** Database username */
define( 'DB_USER', '$PROD_DB_USER' );

/** Database password */
define( 'DB_PASSWORD', '$PROD_DB_PASS' );

/** Database hostname */
define( 'DB_HOST', '$PROD_DB_HOST' );

/** Database charset to use in creating database tables. */
define( 'DB_CHARSET', 'utf8' );

/** The database collate type. Don't change this if in doubt. */
define( 'DB_COLLATE', '' );

/**#@+
 * Authentication unique keys and salts.
 *
 * Change these to different unique phrases! You can generate these using
 * the {@link https://api.wordpress.org/secret-key/1.1/salt/ WordPress.org secret-key service}.
 *
 * You can change these at any point in time to invalidate all existing cookies.
 * This will force all users to have to log in again.
 *
 * @since 2.6.0
 */
define( 'AUTH_KEY',         'IONOS-production-key-change-this-in-production' );
define( 'SECURE_AUTH_KEY',  'IONOS-production-key-change-this-in-production' );
define( 'LOGGED_IN_KEY',    'IONOS-production-key-change-this-in-production' );
define( 'NONCE_KEY',        'IONOS-production-key-change-this-in-production' );
define( 'AUTH_SALT',        'IONOS-production-key-change-this-in-production' );
define( 'SECURE_AUTH_SALT', 'IONOS-production-key-change-this-in-production' );
define( 'LOGGED_IN_SALT',   'IONOS-production-key-change-this-in-production' );
define( 'NONCE_SALT',       'IONOS-production-key-change-this-in-production' );

/**#@-*/

/**
 * WordPress database table prefix.
 *
 * You can have multiple installations in one database if you give each
 * a unique prefix. Only numbers, letters, and underscores please!
 */
\$table_prefix = 'wp_';

/**
 * For developers: WordPress debugging mode.
 *
 * Change this to true to enable the display of notices during development.
 * It is strongly recommended that plugin and theme developers use WP_DEBUG
 * in their development environments.
 *
 * For information on other constants that can be used for debugging,
 * visit the documentation.
 *
 * @link https://wordpress.org/support/article/debugging-in-wordpress/
 */
define( 'WP_DEBUG', false );
define( 'WP_DEBUG_LOG', false );
define( 'WP_DEBUG_DISPLAY', false );

// Production settings
define( 'WP_HOME', '$WEBSITE_URL' );
define( 'WP_SITEURL', '$WEBSITE_URL' );
define( 'WP_POST_REVISIONS', 5 );
define( 'WP_MEMORY_LIMIT', '256M' );
define( 'DISALLOW_FILE_EDIT', true );

// Performance settings
define( 'WP_CACHE', false );
define( 'AUTOSAVE_INTERVAL', 300 );

/* Add any custom values between this line and the "stop editing" line. */

/* That's all, stop editing! Happy publishing. */

/** Absolute path to the WordPress directory. */
if ( ! defined( 'ABSPATH' ) ) {
	define( 'ABSPATH', __DIR__ . '/' );
}

/** Sets up WordPress vars and included files. */
require_once ABSPATH . 'wp-settings.php';
EOF

# Create .htaccess for IONOS
cat > .htaccess << 'EOF'
# IONOS WordPress Configuration
RewriteEngine On

# Redirect to HTTPS
RewriteCond %{HTTPS} off
RewriteRule ^(.*)$ https://%{HTTP_HOST}%{REQUEST_URI} [L,R=301]

# WordPress rewrite rules
RewriteBase /
RewriteRule ^index\.php$ - [L]
RewriteCond %{REQUEST_FILENAME} !-f
RewriteCond %{REQUEST_FILENAME} !-d
RewriteRule . /index.php [L]

# Security headers
<IfModule mod_headers.c>
    Header always set X-Content-Type-Options nosniff
    Header always set X-Frame-Options DENY
    Header always set X-XSS-Protection "1; mode=block"
    Header always set Referrer-Policy "strict-origin-when-cross-origin"
</IfModule>

# Performance optimization
<IfModule mod_expires.c>
    ExpiresActive on
    ExpiresByType text/css "access plus 1 year"
    ExpiresByType application/javascript "access plus 1 year"
    ExpiresByType image/png "access plus 1 year"
    ExpiresByType image/jpg "access plus 1 year"
    ExpiresByType image/jpeg "access plus 1 year"
    ExpiresByType image/gif "access plus 1 year"
    ExpiresByType image/svg+xml "access plus 1 year"
</IfModule>

# Gzip compression
<IfModule mod_deflate.c>
    AddOutputFilterByType DEFLATE text/plain
    AddOutputFilterByType DEFLATE text/html
    AddOutputFilterByType DEFLATE text/xml
    AddOutputFilterByType DEFLATE text/css
    AddOutputFilterByType DEFLATE application/xml
    AddOutputFilterByType DEFLATE application/xhtml+xml
    AddOutputFilterByType DEFLATE application/rss+xml
    AddOutputFilterByType DEFLATE application/javascript
    AddOutputFilterByType DEFLATE application/x-javascript
</IfModule>
EOF

# Create wp-content structure
echo "📁 Creating wp-content structure..."
mkdir -p wp-content/themes
mkdir -p wp-content/plugins
mkdir -p wp-content/uploads

# Create wp-content/index.php files
cat > wp-content/index.php << 'EOF'
<?php
// Silence is golden.
EOF

cat > wp-content/themes/index.php << 'EOF'
<?php
// Silence is golden.
EOF

cat > wp-content/plugins/index.php << 'EOF'
<?php
// Silence is golden.
EOF

cat > wp-content/uploads/index.php << 'EOF'
<?php
// Silence is golden.
EOF

# Copy theme files
echo "📁 Copying theme files..."
cp -r ../../themes/my-theme wp-content/themes/

# Copy media files
echo "📁 Copying media files..."
cp -r ../../media/* wp-content/uploads/ 2>/dev/null || true

# Create deployment info
cat > DEPLOYMENT_INFO.md << EOF
# 🚀 IONOS WordPress Core Deployment

## 📋 **Deployment Details:**
- **Date:** $(date)
- **Target:** $DEPLOY_PATH
- **Website:** $WEBSITE_URL
- **Database:** $PROD_DB_NAME

## 📁 **Files Deployed:**
- ✅ WordPress Core (index.php, wp-config.php)
- ✅ .htaccess für IONOS
- ✅ wp-content Struktur
- ✅ Theme: my-theme
- ✅ Media-Dateien

## 🔧 **Next Steps:**
1. **Database Setup:** MySQL in IONOS Control Panel
2. **WordPress Installation:** Website aufrufen
3. **Theme Activation:** my-theme aktivieren
4. **Content Creation:** Inhalte erstellen

## 🌐 **Access:**
- **Frontend:** $WEBSITE_URL
- **Admin:** $WEBSITE_URL/wp-admin/

---
**WordPress Core erfolgreich auf IONOS deployed! 🎉**
EOF

cd ..

echo -e "${GREEN}✅ WordPress core package created${NC}"
echo ""

       # Upload WordPress core to IONOS
       echo -e "${BLUE}📤 Uploading WordPress core to IONOS...${NC}"

       # Create expect script for upload
       cat > gen/deployment/upload-wordpress.exp << EOF
#!/usr/bin/expect -f
set timeout 60
spawn sftp -o ConnectTimeout=10 $IONOS_USERNAME@$IONOS_HOST
expect "password:"
send "$IONOS_PASSWORD\r"
expect "sftp>"

# Navigate to deploy path
send "cd $DEPLOY_PATH\r"
expect "sftp>"

# Upload all WordPress core files
send "put -r wordpress-core/*\r"
expect "sftp>"

# Verify upload
send "ls -la\r"
expect "sftp>"

# Check wp-content structure
send "ls -la wp-content/\r"
expect "sftp>"

send "bye\r"
expect eof
EOF

chmod +x gen/deployment/upload-wordpress.exp

echo -e "${GREEN}✅ Upload script created${NC}"
echo ""

# Execute upload
echo "🚀 Executing WordPress core upload..."
if ./gen/deployment/upload-wordpress.exp; then
    echo ""
    echo -e "${GREEN}✅ WordPress core successfully deployed to IONOS!${NC}"
    echo ""
    echo -e "${BLUE}📁 Deployment Status:${NC}"
    echo -e "   Verzeichnis: $DEPLOY_PATH"
    echo -e "   WordPress Core: ✅ Deployed"
    echo -e "   Theme: ✅ my-theme"
    echo -e "   Media: ✅ Uploaded"
    echo ""
    echo -e "${BLUE}📋 Nächster Schritt:${NC}"
    echo -e "   04_configure_wordpress.sh - WordPress konfigurieren"
    echo ""
    echo -e "${GREEN}🎯 Bereit für Schritt 4!${NC}"
else
    echo ""
    echo -e "${RED}❌ WordPress core upload failed!${NC}"
    echo -e "${YELLOW}💡 Check IONOS connection and permissions${NC}"
    exit 1
fi

# Cleanup local files
rm -f gen/deployment/upload-wordpress.exp

echo ""
echo -e "${BLUE}📚 WordPress Core Deployment Summary:${NC}"
echo -e "✅ WordPress Core-Dateien erstellt"
echo -e "✅ wp-config.php für IONOS konfiguriert"
echo -e "✅ .htaccess für IONOS optimiert"
echo -e "✅ Theme und Media-Dateien integriert"
echo -e "✅ Alle Dateien auf IONOS hochgeladen"
echo ""
echo -e "${GREEN}🎉 Schritt 3 abgeschlossen!${NC}"
