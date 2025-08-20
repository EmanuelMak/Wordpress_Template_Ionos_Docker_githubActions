# 🧪 WordPress Docker Development Setup - Test Suite

Diese Test-Suite validiert die Funktionalität und Performance des WordPress Docker Development Setups.

## 📋 Verfügbare Tests

### 1. **Funktionalitätstests** (`test-suite.sh`)
Testet alle grundlegenden Funktionen:

- ✅ Docker-Container laufen
- ✅ WordPress ist erreichbar
- ✅ Datenbank-Verbindung funktioniert
- ✅ Theme ist aktiviert
- ✅ WP-CLI ist verfügbar
- ✅ Dateien und Verzeichnisse existieren
- ✅ Apache-Module sind aktiviert
- ✅ PHP-Erweiterungen sind geladen

### 2. **Performance-Tests** (`performance-test.sh`)
Testet die Performance:

- ⚡ Homepage-Ladezeit
- ⚡ Admin-Bereich-Ladezeit
- ⚡ Datenbank-Antwortzeit
- ⚡ Container-Ressourcenverbrauch
- ⚡ Gleichzeitige Anfragen

## 🚀 Tests ausführen

### Alle Tests ausführen:
```bash
task test:all
```

### Nur Funktionalitätstests:
```bash
task test
# oder
./tests/test-suite.sh
```

### Nur Performance-Tests:
```bash
task test:performance
# oder
./tests/performance-test.sh
```

### Schnelltests (ohne WP-CLI):
```bash
task test:quick
```

### WP-CLI-spezifische Tests:
```bash
task test:wp-cli
```

## 📊 Test-Ergebnisse interpretieren

### Funktionalitätstests:
- **✅ PASS**: Funktion arbeitet korrekt
- **❌ FAIL**: Funktion hat ein Problem

### Performance-Tests:
- **✅ Good**: Performance ist akzeptabel
- **⚠️ Slow**: Performance könnte verbessert werden

## 🔧 Troubleshooting

### WP-CLI-Probleme:
```bash
# WP-CLI als Root ausführen
docker exec wp wp --version --allow-root
```

### Theme-Probleme:
```bash
# Theme manuell aktivieren
docker exec wp wp theme activate my-theme --allow-root
```

### Datenbank-Probleme:
```bash
# Datenbank-Status prüfen
docker exec wp-db mysql -u wp_user -pwp_password -e 'SELECT 1;'
```

## 📈 Performance-Benchmarks

### Akzeptable Werte:
- **Homepage-Ladezeit**: < 2 Sekunden
- **Admin-Ladezeit**: < 3 Sekunden
- **Datenbank-Antwortzeit**: < 0.5 Sekunden
- **Speicherverbrauch**: < 512MB
- **CPU-Verbrauch**: < 50%

## 🛠️ Tests erweitern

### Neuen Test hinzufügen:
1. Test-Funktion in `test-suite.sh` hinzufügen
2. Test-Logik implementieren
3. Erwartetes Ergebnis definieren

### Performance-Test erweitern:
1. Neue Metrik in `performance-test.sh` hinzufügen
2. Benchmark-Werte definieren
3. Ausgabe formatieren

## 📝 Continuous Integration

Die Tests werden automatisch in der GitHub Actions Pipeline ausgeführt:

1. **Pre-deployment Tests**: Vor dem Deployment
2. **Package Validation**: Überprüfung des Deployment-Packages
3. **Content Verification**: Validierung der Inhalte

## 🎯 Best Practices

1. **Regelmäßige Tests**: Führen Sie Tests vor jedem Commit aus
2. **Performance-Monitoring**: Überwachen Sie Performance-Metriken
3. **Automated Testing**: Integrieren Sie Tests in CI/CD-Pipeline
4. **Documentation**: Dokumentieren Sie neue Tests
5. **Benchmark-Updates**: Aktualisieren Sie Benchmarks bei Änderungen
