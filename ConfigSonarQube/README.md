# Pasos para levantar el ambiente

## 1. Levantar todo
- docker-compose up -d

## 2. Esperar ~1 min y crear el proyecto en http://localhost:9000
- admin / admin → New Project → guarda el token en .env

## 3. Clonar el repo
- docker exec -it node_analyzer sh
- apt-get update && apt-get install -y git
- git clone https://github.com/testsmith-io/practice-software-testing .
- mv practice-software-testing/* .
- mv practice-software-testing/.* . 2>/dev/null
- exit

## 4. Copiar el script al contenedor y ejecutarlo
- docker cp analyze.sh node_analyzer:/app/analyze.sh

## 5. Obtener el token en SonarQube (http://localhost:9000) y pegarlo en .env

## 6. Ejecutar SonarQube y ESLint
- docker exec -it node_analyzer sh /app/analyze.sh

## 7. Ver resultados en http://localhost:9000