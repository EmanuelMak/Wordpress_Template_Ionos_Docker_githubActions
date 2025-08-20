# 🚀 WordPress Docker Development Template

WordPress-Entwicklungstemplate ionos Workspace als production env und local Docker env, github actions deployment zu ionos Workspace via sftp.

## ✨ Features

- 🐳 **Docker-basierte Entwicklungsumgebung**
- 🔄 **Automatisches Deployment auf IONOS** (GitHub Actions)
- 🎨 **Theme-Entwicklung mit Hot-Reload**
- 📦 **Production-ready Setup**
- 🔧 **Einfache Task-Management mit Taskfile**
- 🔒 **Sichere Konfiguration über .env**

## 🛠️ Quick Start

### 1. Repository klonen
```bash
git clone <your-repo-url>
cd wordpress_git_docker_Dev_Setup
```

### 2. Umgebung konfigurieren
```bash
cp env.example .env
# Bearbeite .env mit deinen Einstellungen
```

### 3. Container starten
```bash
task up:build
```

### 4. WordPress öffnen
- **Frontend:** http://localhost:8000
- **Admin:** http://localhost:8000/wp-admin
- **Admin Login:** Siehe .env Datei

## 📁 Projektstruktur

```
wordpress_git_docker_Dev_Setup/
├── .github/workflows/     # CI/CD Pipeline
├── themes/my-theme/       # Ihr WordPress Theme
├── media/                 # Uploads & Media
├── docker-compose.yml     # Docker Services
├── dockerfile.wp          # WordPress Container
├── taskfile.yml          # Task Management
├── .env                  # Konfiguration (nicht in Git)
└── README.md             # Diese Datei
```

## 🎯 Development Workflow

### Theme-Entwicklung
```bash
# Theme-Verzeichnis öffnen
cd themes/my-theme

# Entwicklung starten
task up

# Logs anzeigen
task logs

# In Container einsteigen
task wpshell
```

### Nützliche Commands
```bash
task up              # Container starten
task down            # Container stoppen
task restart         # Neustart
task clean           # Alles löschen
task logs            # Logs anzeigen
task wpshell         # WordPress Shell
task dbshell         # Database Shell
```

## 🚀 Deployment

### Automatisches Deployment
1. **GitHub Secrets konfigurieren:**
   - `IONOS_USERNAME`: Ihr IONOS Benutzername
   - `IONOS_PASSWORD`: Ihr IONOS Passwort
   - `IONOS_HOST`: IONOS Server Hostname
   - `DEPLOY_PATH`: Zielverzeichnis auf Server
   - `WEBSITE_URL`: Ihre Website URL

2. **Deployment auslösen:**
   - Push auf `main` Branch
   - Oder manuell über GitHub Actions

### Manuelles Deployment
```bash
# Production Build erstellen
task build:prod

# Auf Server hochladen
scp -r deploy/ user@server:/path/to/wordpress/
```

## 🔧 Konfiguration

### .env Datei
```bash
# Kopiere Beispiel-Konfiguration
cp env.example .env

# Bearbeite die Werte:
DB_NAME=wordpress
DB_USER=wp_user
DB_PASS=secure_password
WORDPRESS_TITLE="Meine Website"
WORDPRESS_ADMIN_USER=admin
WORDPRESS_ADMIN_PASSWORD=secure_password
WORDPRESS_ADMIN_EMAIL=admin@example.com
```

### Theme-Entwicklung
- **Hot-Reload:** Theme-Änderungen werden automatisch erkannt
- **Custom Post Types:** In `themes/my-theme/inc/` definieren
- **Assets:** CSS/JS in `themes/my-theme/assets/`

## 🛡️ Security Best Practices

1. **Starke Passwörter** in .env verwenden
2. **.env niemals committen** (ist in .gitignore)
3. **Regelmäßige Updates** von WordPress und Plugins
4. **HTTPS** in Production verwenden
5. **Backup-Strategie** implementieren

## 📚 Nächste Schritte

### Für neue Projekte:
1. Repository forken/klonen
2. `.env` anpassen
3. Theme in `themes/my-theme/` entwickeln
4. GitHub Secrets für Deployment konfigurieren
5. Auf `main` pushen für automatisches Deployment

### Theme-Entwicklung:
- [WordPress Theme Handbook](https://developer.wordpress.org/themes/)
- [WordPress Coding Standards](https://developer.wordpress.org/coding-standards/)
- [Docker Best Practices](https://docs.docker.com/develop/dev-best-practices/)

## 🤝 Support

Bei Fragen oder Problemen:
1. GitHub Issues erstellen
2. Docker Logs prüfen: `task logs`
3. Container Status: `docker ps`

---

**Entwickelt mit ❤️ für effiziente WordPress-Entwicklung**
