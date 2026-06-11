#!/bin/sh
# analyze.sh — corre esto dentro del contenedor node_analyzer

set -e

echo "=== Instalando Java (requerido por sonar-scanner) ==="
apt-get update -qq && apt-get install -y -qq default-jre

echo "=== Instalando dependencias del proyecto ==="
npm install --legacy-peer-deps

echo "=== Instalando ESLint y sus dependencias ==="
npm install --save-dev eslint @eslint/js --legacy-peer-deps

echo "=== Instalando sonar-scanner ==="
npm install -g sonar-scanner --unsafe-perm

echo "=== Creando configuracion de ESLint ==="
cat > eslint.config.mjs << 'ESLINT'
import js from "@eslint/js";
export default [
  js.configs.recommended,
  {
    rules: {
      "no-unused-vars": "warn",
      "no-undef": "warn",
      "no-console": "off"
    }
  }
];
ESLINT

echo "=== Ejecutando ESLint ==="
npx eslint . --ext .js,.ts,.jsx,.tsx \
  --format json \
  --output-file eslint-report.json \
  || true

echo "ESLint terminado. Reporte en: /app/eslint-report.json"

echo "=== Ejecutando SonarScanner ==="
SCANNER=$(find /usr/local/lib/node_modules/sonar-scanner -name "sonar-scanner" -type f | head -1)
chmod +x "$SCANNER"
"$SCANNER" \
  -Dsonar.projectKey=toolshop \
  -Dsonar.sources=. \
  -Dsonar.host.url=$SONAR_HOST_URL \
  -Dsonar.token=$SONAR_TOKEN \
  -Dsonar.javascript.eslint.reportPaths=eslint-report.json \
  -Dsonar.exclusions=node_modules/**,dist/**,build/**

echo "=== Analisis completo ==="
echo "Resultados en: http://localhost:9000"