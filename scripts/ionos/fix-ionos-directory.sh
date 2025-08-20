#!/bin/bash

# WordPress Docker Development Setup - Fix IONOS Directory Structure
# Korrigiert die Verzeichnisstruktur auf IONOS

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}🔧 Fix IONOS Directory Structure${NC}"
echo -e "${BLUE}==================================${NC}"
echo ""

# Load environment variables
if [ -f ".env" ]; then
    echo -e "${GREEN}✅ Loading .env file...${NC}"
    export $(cat .env | grep -v '^#' | xargs)
else
    echo -e "${RED}❌ .env file not found!${NC}"
    exit 1
fi

echo -e "${BLUE}🔍 IONOS Configuration:${NC}"
echo -e "Host: ${GREEN}$IONOS_HOST${NC}"
echo -e "User: ${GREEN}$IONOS_USERNAME${NC}"
echo -e "Deploy Path: ${GREEN}$DEPLOY_PATH${NC}"
echo -e "Website URL: ${GREEN}$WEBSITE_URL${NC}"
echo ""

echo -e "${YELLOW}⚠️ Problem:${NC}"
echo -e "Das Verzeichnis $DEPLOY_PATH existiert nicht auf IONOS"
echo -e "Alle Dateien wurden in das Root-Verzeichnis hochgeladen"
echo ""

# Create expect script to fix directory structure
echo -e "${BLUE}📝 Creating IONOS directory fix script...${NC}"
cat > fix-ionos-dir.exp << EOF
#!/usr/bin/expect -f
set timeout 30
spawn sftp -o ConnectTimeout=10 $IONOS_USERNAME@$IONOS_HOST
expect "password:"
send "$IONOS_PASSWORD\r"
expect "sftp>"

# Check current directory
send "pwd\r"
expect "sftp>"

# List current files
send "ls -la\r"
expect "sftp>"

# Create target directory (relative path)
send "mkdir dev\r"
expect "sftp>"
send "mkdir dev/WordpressTemplate\r"
expect "sftp>"

# Check if directory was created
send "ls -la dev/WordpressTemplate\r"
expect "sftp>"

# Move WordPress files to target directory
send "mv index.php dev/WordpressTemplate/\r"
expect "sftp>"
send "mv wp-config.php dev/WordpressTemplate/\r"
expect "sftp>"
send "mv wp-content dev/WordpressTemplate/\r"
expect "sftp>"
send "mv IONOS_DEPLOYMENT_GUIDE.md dev/WordpressTemplate/\r"
expect "sftp>"

# Verify final structure
send "ls -la $DEPLOY_PATH/\r"
expect "sftp>"

# Show root directory (should be clean now)
send "ls -la\r"
expect "sftp>"

send "bye\r"
expect eof
EOF

chmod +x fix-ionos-dir.exp

echo -e "${GREEN}✅ IONOS directory fix script created${NC}"
echo ""

echo -e "${YELLOW}⚠️ This script will fix the IONOS directory structure${NC}"
echo -e "It will:"
echo -e "1. Create $DEPLOY_PATH directory"
echo -e "2. Move WordPress files there"
echo -e "3. Clean up the root directory"
echo ""
read -p "Continue? (y/N): " -n 1 -r
echo ""

if [[ $REPLY =~ ^[Yy]$ ]]; then
    echo -e "${BLUE}🚀 Fixing IONOS directory structure...${NC}"
    
    if ./fix-ionos-dir.exp; then
        echo ""
        echo -e "${GREEN}✅ IONOS directory structure fixed successfully!${NC}"
        echo ""
        echo -e "${BLUE}📁 New structure on IONOS:${NC}"
        echo "Path: $DEPLOY_PATH"
        echo "Files: WordPress files moved to correct location"
        echo ""
        echo -e "${GREEN}🎯 Next steps:${NC}"
        echo "1. IONOS Control Panel öffnen"
        echo "2. MySQL-Datenbank erstellen"
        echo "3. wp-config.php mit Datenbank-Credentials aktualisieren"
        echo ""
        echo -e "${GREEN}🌐 Your site will be available at: $WEBSITE_URL${NC}"
    else
        echo ""
        echo -e "${RED}❌ Directory structure fix failed!${NC}"
        echo -e "${YELLOW}💡 You may need to manually fix this on IONOS${NC}"
    fi
else
    echo -e "${YELLOW}⏸️ Directory structure fix cancelled${NC}"
fi

# Cleanup
echo ""
echo -e "${BLUE}🧹 Cleaning up...${NC}"
rm -f fix-ionos-dir.exp
echo -e "${GREEN}✅ Cleanup completed${NC}"

echo ""
echo -e "${BLUE}📋 Manual IONOS Fix Instructions:${NC}"
echo "If the automated fix doesn't work, manually:"
echo ""
echo "1. SFTP into IONOS:"
echo "   sftp $IONOS_USERNAME@$IONOS_HOST"
echo ""
echo "2. Create directory:"
echo "   mkdir $DEPLOY_PATH"
echo ""
echo "3. Move files:"
echo "   mv index.php wp-config.php wp-content IONOS_DEPLOYMENT_GUIDE.md $DEPLOY_PATH/"
echo ""
echo "4. Verify:"
echo "   ls -la $DEPLOY_PATH/"
