# 🌿 Branch Strategy & CI/CD Workflow

## 📋 Branch-Struktur

### **Hauptbranches:**
- **`main`** - Entwicklungsversion (Tests bei jedem Push)
- **`prod`** - Production-Version (Deployment auf IONOS)

### **Feature-Branches:**
- **`develop`** - Integration-Branch für Features
- **`feature/*`** - Feature-Entwicklung (z.B. `feature/new-theme`)
- **`hotfix/*`** - Dringende Fixes (z.B. `hotfix/security-patch`)

## 🔄 CI/CD Workflow

### **1. Development Workflow:**
```bash
# Feature-Branch erstellen
git checkout -b feature/new-feature

# Entwickeln und committen
git add .
git commit -m "feat: add new feature"

# Push auf Feature-Branch
git push origin feature/new-feature
# → Trigger: CI-Tests laufen automatisch
```

### **2. Integration Workflow:**
```bash
# Feature in develop mergen
git checkout develop
git merge feature/new-feature
git push origin develop
# → Trigger: CI-Tests laufen automatisch
```

### **3. Production Workflow:**
```bash
# develop in main mergen
git checkout main
git merge develop
git push origin main
# → Trigger: CI-Tests laufen automatisch

# main in prod mergen (nur wenn bereit für Production)
git checkout prod
git merge main
git push origin prod
# → Trigger: CI-Tests + Deployment auf IONOS
```

## 🧪 CI/CD Pipeline

### **CI-Pipeline (bei jedem Push):**
- ✅ **Docker Compose Validierung**
- ✅ **Theme-Struktur Tests**
- ✅ **Script-Validierung**
- ✅ **Environment-Konfiguration**
- ✅ **Security-Checks**
- ✅ **Dokumentation-Tests**

### **CD-Pipeline (nur bei prod-Branch):**
- 🚀 **Production-Build erstellen**
- 🧪 **Comprehensive Pre-Deployment Tests**
- 📦 **Package-Integrität prüfen**
- 🌐 **Deployment auf IONOS**
- ✅ **Deployment-Bestätigung**

## 📊 Branch-Protection Rules

### **main Branch:**
- ✅ CI-Tests müssen bestanden haben
- ✅ Code Review erforderlich
- ✅ Keine direkten Pushes (nur via Pull Request)

### **prod Branch:**
- ✅ CI-Tests müssen bestanden haben
- ✅ Code Review erforderlich
- ✅ Keine direkten Pushes
- 🚀 Automatisches Deployment nach erfolgreichen Tests

## 🛠️ GitHub Actions Workflows

### **1. CI Workflow (`.github/workflows/ci.yml`)**
**Trigger:** Push auf `main`, `develop`, `feature/*`, `hotfix/*`
**Zweck:** Code-Qualität und Konfiguration validieren

### **2. Deploy Workflow (`.github/workflows/deploy.yml`)**
**Trigger:** Push auf `prod`
**Zweck:** Production-Deployment auf IONOS

## 🔧 Lokale Entwicklung

### **Setup für neue Features:**
```bash
# Repository klonen
git clone <your-repo-url>
cd wordpress_git_docker_Dev_Setup

# Environment konfigurieren
cp env.example .env
# .env bearbeiten

# Container starten
task up:build

# Feature-Branch erstellen
git checkout -b feature/your-feature-name
```

### **Tests lokal ausführen:**
```bash
# Funktionalitätstests
./tests/test-suite.sh

# Performance-Tests
./tests/performance-test.sh

# Alle Tests
./tests/test-suite.sh && ./tests/performance-test.sh
```

## 📝 Commit-Konventionen

### **Commit-Types:**
- `feat:` - Neue Features
- `fix:` - Bug-Fixes
- `docs:` - Dokumentation
- `style:` - Code-Formatierung
- `refactor:` - Code-Refactoring
- `test:` - Tests hinzufügen/ändern
- `chore:` - Build-Prozess, Tools

### **Beispiele:**
```bash
git commit -m "feat: add custom post types"
git commit -m "fix: resolve database connection issue"
git commit -m "docs: update deployment instructions"
git commit -m "test: add performance benchmarks"
```

## 🚨 Rollback-Strategie

### **Bei Deployment-Problemen:**
```bash
# Zurück zu vorheriger prod-Version
git checkout prod
git reset --hard HEAD~1
git push --force origin prod
# → Trigger: Rollback-Deployment
```

### **Bei Feature-Problemen:**
```bash
# Feature-Branch löschen
git checkout main
git branch -D feature/problematic-feature
git push origin --delete feature/problematic-feature
```

## 📈 Monitoring & Alerts

### **Deployment-Monitoring:**
- ✅ Deployment-Status in GitHub Actions
- ✅ Website-Erreichbarkeit nach Deployment
- ✅ Performance-Metriken nach Deployment

### **Error-Handling:**
- ❌ Failed Tests → Kein Deployment
- ❌ Build-Fehler → Rollback
- ❌ Deployment-Fehler → Automatische Benachrichtigung

## 🎯 Best Practices

1. **Kleine, häufige Commits** statt großer, seltener Commits
2. **Beschreibende Commit-Messages** verwenden
3. **Tests vor jedem Push** ausführen
4. **Code Review** für alle Changes
5. **Feature-Branches** für neue Features
6. **Hotfix-Branches** für dringende Fixes
7. **Dokumentation** bei Änderungen aktualisieren

---

**Diese Branch-Strategie gewährleistet eine sichere, getestete und automatisierte Deployment-Pipeline! 🚀**
