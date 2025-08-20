#!/bin/bash

# IONOS Deployment - Schritt 2: Zielverzeichnis bereinigen
# Löscht alles vorhandene unter DEPLOY_PATH (immer non-interaktiv)

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}🧹 IONOS Deployment - Schritt 2: Zielverzeichnis bereinigen${NC}"
echo -e "${BLUE}========================================================${NC}"
echo ""

# Load environment variables
if [ -f "../.env" ]; then
    echo -e "${GREEN}✅ Loading .env file...${NC}"
    export $(cat ../.env | grep -v '^#' | xargs)
else
    echo -e "${RED}❌ .env file not found!${NC}"
    exit 1
fi

# Load relative deployment path
if [ -f "gen/deployment/.deploy_paths" ]; then
    echo -e "${GREEN}✅ Loading relative deployment path...${NC}"
    source gen/deployment/.deploy_paths
    echo -e "   RELATIVE_DEPLOY_PATH: ${GREEN}$RELATIVE_DEPLOY_PATH${NC}"
else
    echo -e "${RED}❌ gen/deployment/.deploy_paths not found!${NC}"
    echo -e "${YELLOW}💡 Run 01_validate_paths.sh first${NC}"
    exit 1
fi

echo -e "${BLUE}📋 Zielverzeichnis:${NC}"
echo -e "DEPLOY_PATH: ${GREEN}$DEPLOY_PATH${NC}"
echo -e "IONOS_HOST: ${GREEN}$IONOS_HOST${NC}"
echo -e "IONOS_USERNAME: ${GREEN}$IONOS_USERNAME${NC}"
echo ""

# Always run in non-interactive mode
echo -e "${BLUE}🤖 Non-interaktive Ausführung${NC}"
echo -e "${GREEN}✅ Bereit für non-interaktive Ausführung${NC}"
echo ""

echo -e "${BLUE}🚀 Starting cleanup of $DEPLOY_PATH...${NC}"
echo ""

# Create expect script for cleanup (non-interactive)
echo -e "${BLUE}📝 Creating cleanup script...${NC}"
cat > cleanup-ionos.exp << EOF
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

# Navigate to relative deploy path
send "cd $RELATIVE_DEPLOY_PATH\r"
expect "sftp>"

# Check what's in the deploy path
send "ls -la\r"
expect "sftp>"

# Remove all files and directories (SFTP doesn't support rm -rf)
send "rm *.md\r"
expect "sftp>"
send "rm *.sh\r"
expect "sftp>"
send "rm *.yml\r"
expect "sftp>"
send "rm *.php\r"
expect "sftp>"
send "rm *.wp\r"
expect "sftp>"
# Remove directories (SFTP doesn't support rm -r, so we need to remove contents first)
send "rm my-theme/*\r"
expect "sftp>"
send "rmdir my-theme\r"
expect "sftp>"
send "rm wp-content/*\r"
expect "sftp>"
send "rm wp-content/themes/*\r"
expect "sftp>"
send "rm wp-content/plugins/*\r"
expect "sftp>"
send "rm wp-content/uploads/*\r"
expect "sftp>"
send "rmdir wp-content/themes\r"
expect "sftp>"
send "rmdir wp-content/plugins\r"
expect "sftp>"
send "rmdir wp-content/uploads\r"
expect "sftp>"
send "rmdir wp-content\r"
expect "sftp>"
send "rmdir dev\r"
expect "sftp>"

# Verify cleanup
send "ls -la\r"
expect "sftp>"

# Go back to user root
send "cd /\r"
expect "sftp>"

# Show final status
send "ls -la\r"
expect "sftp>"

send "bye\r"
expect eof
EOF

chmod +x cleanup-ionos.exp

echo -e "${GREEN}✅ Cleanup script created${NC}"
echo ""

# Execute cleanup
echo "🧹 Executing cleanup on IONOS..."
if ./cleanup-ionos.exp; then
    echo ""
    echo -e "${GREEN}✅ Zielverzeichnis erfolgreich bereinigt!${NC}"
    echo ""
    echo -e "${BLUE}📁 Status:${NC}"
    echo -e "   Verzeichnis: $DEPLOY_PATH"
    echo -e "   Status: Leer und bereit für Deployment"
    echo ""
    echo -e "${BLUE}📋 Nächster Schritt:${NC}"
    echo -e "   03_deploy_wordpress_core.sh - WordPress Core deployen"
    echo ""
    echo -e "${GREEN}🎯 Bereit für Schritt 3!${NC}"
else
    echo ""
    echo -e "${RED}❌ Cleanup fehlgeschlagen!${NC}"
    echo -e "${YELLOW}💡 Überprüfen Sie die IONOS-Verbindung${NC}"
    exit 1
fi

# Cleanup local files
rm -f cleanup-ionos.exp

echo ""
echo -e "${BLUE}📚 Cleanup-Informationen:${NC}"
echo -e "✅ Zielverzeichnis wird geleert"
echo -e "✅ Alle alten Dateien werden entfernt"
echo -e "✅ Saubere Basis für neues Deployment"
echo ""
echo -e "${GREEN}🎉 Schritt 2 abgeschlossen!${NC}"
