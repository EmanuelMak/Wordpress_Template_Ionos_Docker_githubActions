# 📁 Scripts-Organisation

## 🎯 Übersicht

Das Repository wurde komplett neu organisiert und aufgeräumt. Alle temporären Ordner wurden entfernt und eine logische, produktionsnahe Struktur erstellt.

## 📂 Neue, saubere Ordnerstruktur

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
│       ├── 01_validate_paths.sh
│       ├── 02_clean_deploy_path.sh
│       ├── 03_deploy_wordpress_core.sh
│       ├── 04_configure_wordpress.sh
│       └── check-wordpress-config.sh
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
└── gen/                       # Generierte temporäre Dateien
    ├── wordpress-core/        # WordPress Core Package
    ├── deployment/            # Deployment Scripts & Pfade
    └── backups/               # Backup-Dateien
```

## 🧹 Aufräumarbeiten durchgeführt

### Entfernte temporäre Ordner:
- ❌ `deployment/` - Temporärer Deployment-Ordner
- ❌ `ionos-webhosting/` - Alte IONOS-Konfiguration
- ❌ `IONOS_Deployment/` - In `scripts/ionos/` verschoben
- ❌ `themes/my-theme/` - Durch `themes/custom-theme/` ersetzt
- ❌ `wordpress-core/` - Temporärer WordPress-Core-Ordner

### Entfernte temporäre Dateien:
- ❌ `.deploy_paths` - Temporäre Deployment-Pfade
- ❌ `manual-ionos-fix.md` - Alte Dokumentation
- ❌ `CLEANUP_SUMMARY.md` - Aufräum-Zusammenfassung
- ❌ `BRANCH_STRATEGY.md` - Alte Branch-Strategie

## 🔧 Verwendung

### Lokale Entwicklung
```bash
# WordPress lokal starten
task up:build

# Scripts werden automatisch von Docker verwendet
# Alle Pfade sind korrekt konfiguriert
```

### Setup Scripts
```bash
# Neue Projekte einrichten
./scripts/setup/setup-new-project.sh

# Git Branches konfigurieren
./scripts/setup/setup-branches.sh
```

### Utility Scripts
```bash
# Datenbank-Image generieren
./scripts/utils/generate-db-image.sh

# Oder über Taskfile
task db:switch
task db:mysql
task db:mariadb
```

### IONOS Deployment
```bash
# Vollständiges IONOS-Deployment
./scripts/ionos/01_validate_paths.sh
./scripts/ionos/02_clean_deploy_path.sh
./scripts/ionos/03_deploy_wordpress_core.sh
./scripts/ionos/04_configure_wordpress.sh
```

## 📝 Anpassungen

Alle Pfade wurden in folgenden Dateien aktualisiert:
- ✅ `docker-compose.yml` - Neue Script-Pfade
- ✅ `dockerfile.wp` - Neue Script-Pfade
- ✅ `taskfile.yml` - Neue Script-Pfade
- ✅ `README.md` - Neue Projektstruktur
- ✅ `.gitignore` - Saubere Git-Ignore-Regeln

## 🎨 Neues Custom Theme

Das `themes/custom-theme/` Verzeichnis enthält ein vollständiges WordPress-Theme:
- **style.css** - Theme-Styles
- **index.php** - Haupttemplate
- **header.php** - Header-Template
- **footer.php** - Footer-Template
- **functions.php** - Theme-Funktionen

## ✅ Vorteile der neuen Struktur

1. **Sauberkeit:** Root-Ordner ist komplett aufgeräumt
2. **Logische Gruppierung:** Scripts nach Funktion sortiert
3. **Produktionsnah:** Entwicklungsumgebung ähnelt der Produktion
4. **Wartbarkeit:** Einfacher zu finden und zu verwalten
5. **Skalierbarkeit:** Neue Scripts können einfach hinzugefügt werden
6. **Konsistenz:** Einheitliche Struktur für alle Scripts
7. **IONOS-Ready:** Vollständige Deployment-Pipeline

## 🧹 Gen-Ordner Management

### **Temporäre Dateien löschen:**
```bash
# Alle generierten Dateien löschen
task clean:gen

# Oder manuell
rm -rf gen/
```

### **Was wird im gen/ Ordner erstellt:**
- **gen/wordpress-core/** - WordPress Core Package für IONOS
- **gen/deployment/** - Temporäre Deployment-Scripts und Pfade
- **gen/backups/** - Backup-Dateien (falls benötigt)

## 🚀 Nächste Schritte

1. **Theme entwickeln:** `themes/custom-theme/` anpassen
2. **IONOS-Deployment testen:** Deployment-Scripts ausführen
3. **GitHub Actions konfigurieren:** CI/CD-Pipeline einrichten
4. **Produktionsumgebung:** Auf IONOS deployen

---

**Das Repository ist jetzt professionell organisiert und produktionsbereit! 🎯**
