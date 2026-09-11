#!/usr/bin/env bash
set -e

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"
cd "$DIR"

echo "======================================================"
echo "    EJECUTANDO TODAS LAS PRUEBAS DE LA ACTIVIDAD     "
echo "======================================================"
echo ""

# 1. JUNIT 5 TESTS (JAVA Y KOTLIN)
echo ">>> [1/5] JUnit 5 (Java y Kotlin - User Guide #running-tests)..."
JUNIT_JAR="$DIR/tools/junit-platform-console-standalone-1.10.2.jar"
KOTLIN_STDLIB="$(find /usr "$DIR/tools" -name "kotlin-stdlib.jar" 2>/dev/null | head -n 1)"
CP_ALL="$JUNIT_JAR:$KOTLIN_STDLIB:$DIR/1-junit5-running-tests/bin/java:$DIR/1-junit5-running-tests/bin/kotlin"

java -cp "$CP_ALL" org.junit.platform.console.ConsoleLauncher --scan-class-path --details=tree

# 2. SOFTTEK TESTS (JUnit 4 + Mockito)
echo ""
echo ">>> [2/5] Blog de Softtek (Parseador, EcuacionPrimerGrado, Mockito)..."
CP_SOFTTEK="$DIR/2-softtek-testing-unitario/bin:$DIR/tools/junit-4.13.2.jar:$DIR/tools/hamcrest-core-1.3.jar:$DIR/tools/mockito-core-5.11.0.jar:$DIR/tools/byte-buddy-1.14.12.jar:$DIR/tools/byte-buddy-agent-1.14.12.jar:$DIR/tools/objenesis-3.3.jar"

java -cp "$CP_SOFTTEK" org.junit.runner.JUnitCore com.softtek.ecuacion.ParseadorTest com.softtek.ecuacion.EcuacionPrimerGradoIntegrationTest com.softtek.ecuacion.EcuacionPrimerGradoMockitoTest

# 3. CRUD PYTHON (TDD)
echo ""
echo ">>> [3/5] CRUD con TDD en Python (unittest)..."
cd "$DIR/3-crud-tdd/python"
python3 -m unittest discover -s tests -p "test_*.py" -v

# 4. CRUD GOLANG (TDD)
echo ""
echo ">>> [4/5] CRUD con TDD en Go (testing)..."
cd "$DIR/3-crud-tdd/golang"
go test -v ./...

# 5. CRUD REACT + TYPESCRIPT (TDD)
echo ""
echo ">>> [5/5] CRUD con TDD en React + TypeScript (Vitest)..."
cd "$DIR/3-crud-tdd/frontend-react-ts"
npm test

echo ""
echo "======================================================"
echo "   TODAS LAS SUITES DE PRUEBAS COMPLETADAS CON EXITO  "
echo "======================================================"