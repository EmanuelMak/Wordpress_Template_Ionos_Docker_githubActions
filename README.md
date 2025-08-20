# 🚀 WordPress Docker Development Setup

Ein professionelles WordPress-Entwicklungssetup mit Docker, das eine produktionsnahe Umgebung für lokale Entwicklung bietet.

## ✨ Features

- **🐳 Docker-basiert:** Vollständig containerisierte Entwicklungsumgebung
- **🔄 Produktionsnah:** MySQL 8.0, PHP 8.3, WordPress 6.4.3
- **🎨 Custom Theme:** Eigenes WordPress-Theme für Entwicklung
- **⚡ Automatisierung:** Taskfile-basierte Workflows
- **🔧 Konfigurierbar:** Dynamische Datenbank-Auswahl (MySQL/MariaDB)
- **🚀 IONOS Ready:** Deployment-Scripts für IONOS Webhosting

## 📁 Projektstruktur

```
wordpress_git_docker_Dev_Setup/
├── scripts/                    # Alle Scripts organisiert
│   ├── local/                 # Lokale WordPress-Scripts
│   │   ├── wp-init.sh        # WordPress Initialisierung
│   │   ├── wp-config-create.sh # WordPress Konfiguration
│   │   └── wait-for-db.sh    # Datenbank Warteschleife
│   ├── setup/                 # Projekt Setup Scripts
│   │   ├── setup-branches.sh # Git Branch Setup
│   │   └── setup-new-project.sh # Neues Projekt Setup
│   ├── utils/                 # Utility Scripts
│   │   └── generate-db-image.sh # Datenbank Image Generator
│   └── ionos/                 # IONOS Deployment Scripts
├── config/                     # Konfigurationsdateien
│   ├── local/                 # Lokale Konfiguration
│   └── ionos/                 # IONOS Konfiguration
├── themes/custom-theme/        # Eigenes WordPress Theme
├── media/                      # Medien Dateien
├── tests/                      # Test Suite
├── .github/                    # GitHub Actions
├── docker-compose.yml          # Docker Services
├── dockerfile.wp               # WordPress Container
├── taskfile.yml               # Task Management
├── .env                       # Umgebungsvariablen
└── gen/                       # Generierte temporäre Dateien (kann gelöscht werden)
```

## 🚀 Quick Start

### 1. Repository klonen
```bash
git clone <your-repo>
cd wordpress_git_docker_Dev_Setup
```

### 2. Umgebung konfigurieren
```bash
cp env.example .env
# .env bearbeiten mit Ihren Einstellungen
```

### 3. Entwicklungsumgebung starten
```bash
task up:build
```

### 4. WordPress öffnen
- **Website:** http://localhost:8000
- **Admin:** http://localhost:8000/wp-admin

## 🛠️ Verfügbare Tasks

### Basis-Operationen
```bash
task up              # Container starten
task down            # Container stoppen
task restart         # Neustart
task clean           # Alles löschen
task clean:gen       # Generierte Dateien löschen
task logs            # Logs anzeigen
```

### Entwicklung
```bash
task wpshell         # WordPress Shell öffnen
task dbshell         # Datenbank Shell öffnen
task test            # Alle Tests ausführen
```

### Datenbank-Management
```bash
task db:switch       # DB-Image aktualisieren
task db:mysql        # Auf MySQL 8.0 setzen
task db:mariadb      # Auf MariaDB 11.0 setzen
```

## 🔧 Konfiguration

### .env Datei
```bash
# Development Database
DEV_DB_TYPE=MySQL
DEV_DB_VERSION=8.0
DEV_DB_NAME=wordpress
DEV_DB_USER=wp_user
DEV_DB_PASS=wp_password

# WordPress
PHP_VERSION=8.3
WORDPRESS_TITLE="Meine Website"
WORDPRESS_ADMIN_USER=admin
WORDPRESS_ADMIN_PASSWORD=secure_password
WORDPRESS_ADMIN_EMAIL=admin@example.com

# Production (IONOS)
PROD_DB_TYPE=MySQL
PROD_DB_VERSION=8.0
PROD_DB_NAME=your_prod_db
PROD_DB_USER=your_prod_user
PROD_DB_PASS=your_prod_pass
PROD_DB_HOST=your_prod_host
```

## 🎨 Theme-Entwicklung

Das `themes/custom-theme/` Verzeichnis enthält ein vollständiges WordPress-Theme:

- **style.css** - Theme-Styles
- **index.php** - Haupttemplate
- **header.php** - Header-Template
- **footer.php** - Footer-Template
- **functions.php** - Theme-Funktionen

### Theme anpassen
```bash
# Theme-Verzeichnis öffnen
cd themes/custom-theme

# Änderungen werden automatisch erkannt
# (Hot-Reload funktioniert)
```

## 🚀 IONOS Deployment

### Automatisches Deployment
1. **GitHub Secrets konfigurieren:**
   - `IONOS_USERNAME`: IONOS Benutzername
   - `IONOS_PASSWORD`: IONOS Passwort
   - `IONOS_HOST`: IONOS Server Hostname
   - `DEPLOY_PATH`: Zielverzeichnis auf Server

2. **Deployment auslösen:**
   - Push auf `prod` Branch startet automatisches Deployment

### Manuelles Deployment
```bash
# IONOS Deployment Scripts
./scripts/ionos/01_validate_paths.sh
./scripts/ionos/02_clean_deploy_path.sh
./scripts/ionos/03_deploy_wordpress_core.sh
./scripts/ionos/04_configure_wordpress.sh
```

## 🧪 Testing

### Vollständige Tests
```bash
task test            # Alle Tests ausführen
```

### Einzelne Tests
```bash
./tests/test-suite.sh        # Basis-Funktionalität
./tests/performance-test.sh  # Performance-Tests
```

## 🔒 Security

- **Starke Passwörter** in .env verwenden
- **.env niemals committen** (ist in .gitignore)
- **Regelmäßige Updates** von WordPress und Plugins
- **HTTPS** in Production verwenden

## 📚 Nächste Schritte

1. **Theme entwickeln:** `themes/custom-theme/` anpassen
2. **Plugins hinzufügen:** Benötigte WordPress-Plugins installieren
3. **Content erstellen:** Beispiel-Inhalte für Entwicklung hinzufügen
4. **Deployment testen:** IONOS-Deployment lokal testen

## 🤝 Support

Bei Fragen oder Problemen:
1. **Issues** auf GitHub erstellen
2. **Tests ausführen:** `task test`
3. **Logs prüfen:** `task logs`

---

**Entwickelt mit ❤️ für professionelle WordPress-Entwicklung**
