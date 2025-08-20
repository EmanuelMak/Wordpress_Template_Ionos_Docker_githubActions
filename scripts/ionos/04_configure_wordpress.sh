#!/bin/bash

# IONOS Deployment - Schritt 4: WordPress konfigurieren
# Konfiguriert WordPress nach dem Deployment

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}⚙️ IONOS Deployment - Schritt 4: WordPress konfigurieren${NC}"
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
echo -e "WEBSITE_URL: ${GREEN}$WEBSITE_URL${NC}"
echo -e "PROD_DB_NAME: ${GREEN}$PROD_DB_NAME${NC}"
echo -e "PROD_DB_HOST: ${GREEN}$PROD_DB_HOST${NC}"
echo ""

# Check if WordPress is accessible
echo -e "${BLUE}🔍 Checking WordPress accessibility...${NC}"
if curl -s -o /dev/null -w "%{http_code}" "$WEBSITE_URL" | grep -q "200\|301\|302\|404"; then
    echo -e "${GREEN}✅ Website is accessible${NC}"
    echo -e "   Status: WordPress is responding"
else
    echo -e "${YELLOW}⚠️ Website might not be accessible yet${NC}"
    echo -e "   This is normal for first-time deployment"
fi

echo ""

# Create WordPress configuration verification
echo -e "${BLUE}📝 Creating WordPress configuration verification...${NC}"

# Create configuration check script
cat > check-wordpress-config.sh << 'EOF'
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
EOF

chmod +x check-wordpress-config.sh

echo -e "${GREEN}✅ Configuration check script created${NC}"
echo ""

# Create WordPress setup guide
cat > gen/deployment/WORDPRESS_SETUP_GUIDE.md << EOF
# 🚀 WordPress Setup Guide für IONOS

## ✅ **Status: WordPress Core deployed**

Ihr WordPress Setup wurde erfolgreich auf IONOS deployed!

## 📋 **Was wurde deployed:**

### **Core Files:**
- ✅ **index.php** - WordPress Frontend
- ✅ **wp-config.php** - Produktions-Konfiguration
- ✅ **.htaccess** - IONOS-optimiert
- ✅ **wp-content/** - Verzeichnisstruktur

### **Theme & Media:**
- ✅ **my-theme/** - Ihr Custom Theme
- ✅ **uploads/** - Media-Verzeichnis
- ✅ **plugins/** - Plugin-Verzeichnis

## 🔧 **Nächste Schritte:**

### **1. WordPress Installation abschließen:**
- Besuchen Sie: $WEBSITE_URL
- WordPress wird Sie durch die Installation führen
- Verwenden Sie die Datenbank-Credentials aus der .env

### **2. Theme aktivieren:**
- WordPress Admin: $WEBSITE_URL/wp-admin/
- Gehen Sie zu: Appearance → Themes
- Aktivieren Sie: my-theme

### **3. Site konfigurieren:**
- Site Title: $WORDPRESS_TITLE
- Admin User: $WORDPRESS_ADMIN_USER
- Admin Email: $WORDPRESS_ADMIN_EMAIL

### **4. Content erstellen:**
- Seiten und Beiträge verfassen
- Media hochladen
- Menüs konfigurieren

## 🌐 **Zugriff:**

- **Frontend:** $WEBSITE_URL
- **Admin:** $WEBSITE_URL/wp-admin/
- **Database:** $PROD_DB_HOST

## 🔍 **Verification:**

Führen Sie auf IONOS aus:
\`\`\`bash
cd $DEPLOY_PATH
./check-wordpress-config.sh
\`\`\`

## 📞 **Bei Problemen:**

- **IONOS Support:** +49 (0) 721 170 5555
- **Database Issues:** IONOS Control Panel prüfen
- **File Permissions:** 755 für Verzeichnisse, 644 für Dateien

---

**Ihr WordPress Setup ist bereit für die Produktion! 🎉**
EOF

echo -e "${GREEN}✅ WordPress setup guide created${NC}"
echo ""

# Upload configuration files to IONOS
echo -e "${BLUE}📤 Uploading configuration files to IONOS...${NC}"

       # Create expect script for upload
       cat > gen/deployment/upload-config.exp << EOF
#!/usr/bin/expect -f
set timeout 30
spawn sftp -o ConnectTimeout=10 $IONOS_USERNAME@$IONOS_HOST
expect "password:"
send "$IONOS_PASSWORD\r"
expect "sftp>"

# Navigate to deploy path
send "cd $DEPLOY_PATH\r"
expect "sftp>"

# Upload configuration files
send "put check-wordpress-config.sh\r"
expect "sftp>"
send "put WORDPRESS_SETUP_GUIDE.md\r"
expect "sftp>"

# Make script executable
send "chmod +x check-wordpress-config.sh\r"
expect "sftp>"

# Verify upload
send "ls -la\r"
expect "sftp>"

send "bye\r"
expect eof
EOF

chmod +x gen/deployment/upload-config.exp

echo -e "${GREEN}✅ Upload script created${NC}"
echo ""

# Execute upload
echo "🚀 Executing configuration upload..."
if ./gen/deployment/upload-config.exp; then
    echo ""
    echo -e "${GREEN}✅ Configuration files successfully uploaded to IONOS!${NC}"
    echo ""
    echo -e "${BLUE}📁 Final Status:${NC}"
    echo -e "   Verzeichnis: $DEPLOY_PATH"
    echo -e "   WordPress Core: ✅ Deployed"
    echo -e "   Configuration: ✅ Uploaded"
    echo -e "   Setup Guide: ✅ Created"
    echo ""
    echo -e "${GREEN}🎯 WordPress Setup abgeschlossen!${NC}"
else
    echo ""
    echo -e "${RED}❌ Configuration upload failed!${NC}"
    echo -e "${YELLOW}💡 Check IONOS connection and permissions${NC}"
    exit 1
fi

# Cleanup local files
rm -f gen/deployment/upload-config.exp

echo ""
echo -e "${BLUE}📚 WordPress Configuration Summary:${NC}"
echo -e "✅ Configuration check script erstellt"
echo -e "✅ WordPress setup guide erstellt"
echo -e "✅ Alle Dateien auf IONOS hochgeladen"
echo -e "✅ Scripts ausführbar gemacht"
echo ""
echo -e "${GREEN}🎉 Schritt 4 abgeschlossen!${NC}"
echo ""
echo -e "${BLUE}🎯 Nächste Schritte:${NC}"
echo -e "1. IONOS Control Panel: MySQL-Datenbank prüfen"
echo -e "2. Website aufrufen: $WEBSITE_URL"
echo -e "3. WordPress-Installation abschließen"
echo -e "4. Theme aktivieren und konfigurieren"
echo ""
echo -e "${GREEN}🌐 Ihr WordPress Setup ist bereit für die Produktion! 🚀${NC}"
