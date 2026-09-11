# Justfile para automatizar tareas del proyecto
set windows-shell := ["powershell.exe", "-NoProfile", "-ExecutionPolicy", "Bypass", "-Command"]

default:
    @just --list

# Ejecutar todas las suites de pruebas
test:
    .\run_all_tests.ps1

# Compilar los proyectos Java y Kotlin
build:
    .\build.ps1

# Ejecutar solo JUnit 5 (Java y Kotlin)
test-java:
    & 'tools/jdk-21/bin/java.exe' -cp 'tools/junit-platform-console-standalone-1.10.2.jar;tools/kotlinc/lib/kotlin-stdlib.jar;1-junit5-running-tests/bin/java;1-junit5-running-tests/bin/kotlin' org.junit.platform.console.ConsoleLauncher --scan-class-path --details=tree

# Ejecutar solo Softtek (JUnit 4 + Mockito)
test-softtek:
    & 'tools/jdk-21/bin/java.exe' -cp '2-softtek-testing-unitario/bin;tools/junit-4.13.2.jar;tools/hamcrest-core-1.3.jar;tools/mockito-core-5.11.0.jar;tools/byte-buddy-1.14.12.jar;tools/byte-buddy-agent-1.14.12.jar;tools/objenesis-3.3.jar' org.junit.runner.JUnitCore com.softtek.ecuacion.ParseadorTest com.softtek.ecuacion.EcuacionPrimerGradoIntegrationTest com.softtek.ecuacion.EcuacionPrimerGradoMockitoTest

# Ejecutar pruebas en Python (unittest)
test-python:
    Push-Location 3-crud-tdd/python; python -m unittest discover -s tests -p 'test_*.py' -v; Pop-Location

# Ejecutar pruebas en Go (testing)
test-go:
    Push-Location 3-crud-tdd/golang; go test -v ./...; Pop-Location

# Ejecutar pruebas en React + TypeScript (Vitest)
test-react:
    Push-Location 3-crud-tdd/frontend-react-ts; npm.cmd test; Pop-Location

# Construir imagen Docker
docker-build:
    docker build -t pruebas-gestion-tdd .

# Ejecutar pruebas dentro de Docker
docker-test:
    docker run --rm pruebas-gestion-tdd

# Modo observador continuo con watchexec
watch:
    watchexec -e java,kt,py,go,ts,tsx just test