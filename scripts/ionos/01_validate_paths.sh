#!/bin/bash

# IONOS Deployment - Schritt 1: Path-Validierung
# Validiert IONOS_USER_PATH und DEPLOY_PATH für Zugriffsrechte

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}🔍 IONOS Deployment - Schritt 1: Path-Validierung${NC}"
echo -e "${BLUE}==================================================${NC}"
echo ""

# Load environment variables
if [ -f "../.env" ]; then
    echo -e "${GREEN}✅ Loading .env file...${NC}"
    export $(cat ../.env | grep -v '^#' | xargs)
else
    echo -e "${RED}❌ .env file not found!${NC}"
    exit 1
fi

echo -e "${BLUE}📋 Aktuelle Konfiguration:${NC}"
echo -e "IONOS_USER_PATH: ${GREEN}$IONOS_USER_PATH${NC}"
echo -e "DEPLOY_PATH: ${GREEN}$DEPLOY_PATH${NC}"
echo -e "IONOS_HOST: ${GREEN}$IONOS_HOST${NC}"
echo -e "IONOS_USERNAME: ${GREEN}$IONOS_USERNAME${NC}"
echo ""

# Validate paths
echo -e "${BLUE}🔍 Validierung der Pfade...${NC}"

# Check if IONOS_USER_PATH is part of DEPLOY_PATH
if [[ "$DEPLOY_PATH" == "$IONOS_USER_PATH"* ]]; then
    echo -e "${GREEN}✅ IONOS_USER_PATH ist Teil von DEPLOY_PATH${NC}"
    echo -e "   Der User hat Zugriff auf das Zielverzeichnis"
    
    # Calculate relative deployment path
    if [[ "$DEPLOY_PATH" == "$IONOS_USER_PATH" ]]; then
        # Same path - deploy to user root
        RELATIVE_DEPLOY_PATH="."
        echo -e "${BLUE}📁 Deployment: User Root (gleicher Pfad)${NC}"
    else
        # DEPLOY_PATH is longer - calculate relative path
        RELATIVE_DEPLOY_PATH="${DEPLOY_PATH#$IONOS_USER_PATH}"
        RELATIVE_DEPLOY_PATH="${RELATIVE_DEPLOY_PATH#/}"  # Remove leading slash
        echo -e "${BLUE}📁 Deployment: Relativer Pfad: $RELATIVE_DEPLOY_PATH${NC}"
    fi
    
               # Export for other scripts
           export RELATIVE_DEPLOY_PATH
           echo "export RELATIVE_DEPLOY_PATH=\"$RELATIVE_DEPLOY_PATH\"" > gen/deployment/.deploy_paths
           echo -e "${GREEN}✅ Relative deployment path gespeichert${NC}"
    
else
    echo -e "${RED}❌ FEHLER: Keine Zugriffsrechte!${NC}"
    echo -e "   IONOS_USER_PATH: $IONOS_USER_PATH"
    echo -e "   DEPLOY_PATH: $DEPLOY_PATH"
    echo ""
    echo -e "${YELLOW}⚠️ Das bedeutet:${NC}"
    echo -e "   - Der User kann nicht auf $DEPLOY_PATH zugreifen"
    echo -e "   - Deployment wird fehlschlagen"
    echo -e "   - Website wird nicht funktionieren"
    echo ""
    echo -e "${BLUE}💡 Lösungsvorschläge:${NC}"
    echo -e "   1. IONOS_USER_PATH anpassen: $DEPLOY_PATH"
    echo -e "   2. DEPLOY_PATH anpassen: $IONOS_USER_PATH"
    echo -e "   3. IONOS Support kontaktieren für erweiterte Rechte"
    echo ""
    exit 1
fi

# Check if paths are absolute
if [[ "$DEPLOY_PATH" == /* ]]; then
    echo -e "${GREEN}✅ DEPLOY_PATH ist ein absoluter Pfad${NC}"
else
    echo -e "${YELLOW}⚠️ DEPLOY_PATH ist kein absoluter Pfad${NC}"
    echo -e "   Empfohlen: Absoluten Pfad verwenden (z.B. /dev/WordpressTemplate)"
fi

if [[ "$IONOS_USER_PATH" == /* ]]; then
    echo -e "${GREEN}✅ IONOS_USER_PATH ist ein absoluter Pfad${NC}"
else
    echo -e "${YELLOW}⚠️ IONOS_USER_PATH ist kein absoluter Pfad${NC}"
    echo -e "   Empfohlen: Absoluten Pfad verwenden"
fi

echo ""
echo -e "${GREEN}✅ Path-Validierung erfolgreich abgeschlossen!${NC}"
echo ""
echo -e "${BLUE}📋 Nächster Schritt:${NC}"
echo -e "   02_clean_deploy_path.sh - Zielverzeichnis bereinigen"
echo ""
echo -e "${GREEN}🎯 Bereit für Schritt 2!${NC}"
