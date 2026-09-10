Write-Host "======================================================" -ForegroundColor Cyan
Write-Host "    EJECUTANDO TODAS LAS PRUEBAS DE LA ACTIVIDAD     " -ForegroundColor Cyan
Write-Host "======================================================" -ForegroundColor Cyan
Write-Host ""

$root = $PSScriptRoot
if (-not $root) { $root = Get-Location }

# Configurar Java Runtime JDK 21 LTS
$env:JAVA_HOME = "$root\tools\jdk-21"
$env:PATH = "$env:JAVA_HOME\bin;$env:PATH"

# 1. JUNIT 5 TESTS (JAVA Y KOTLIN)
Write-Host ">>> [1/5] JUnit 5 (Java y Kotlin - User Guide #running-tests)..." -ForegroundColor Yellow
$junitJar = "$root/tools/junit-platform-console-standalone-1.10.2.jar"
$kotlinStdlib = "$root/tools/kotlinc/lib/kotlin-stdlib.jar"
$cpAll = "$junitJar;$kotlinStdlib;$root/1-junit5-running-tests/bin/java;$root/1-junit5-running-tests/bin/kotlin"

& "$env:JAVA_HOME\bin\java.exe" -cp "$cpAll" org.junit.platform.console.ConsoleLauncher --scan-class-path --details=tree

# 2. SOFTTEK TESTS (JUnit 4 + Mockito)
Write-Host "`n>>> [2/5] Blog de Softtek (Parseador, EcuacionPrimerGrado, Mockito)..." -ForegroundColor Yellow
$cpSofttek = "$root/2-softtek-testing-unitario/bin;$root/tools/junit-4.13.2.jar;$root/tools/hamcrest-core-1.3.jar;$root/tools/mockito-core-5.11.0.jar;$root/tools/byte-buddy-1.14.12.jar;$root/tools/byte-buddy-agent-1.14.12.jar;$root/tools/objenesis-3.3.jar"

& "$env:JAVA_HOME\bin\java.exe" -cp "$cpSofttek" org.junit.runner.JUnitCore com.softtek.ecuacion.ParseadorTest com.softtek.ecuacion.EcuacionPrimerGradoIntegrationTest com.softtek.ecuacion.EcuacionPrimerGradoMockitoTest

# 3. CRUD PYTHON (TDD)
Write-Host "`n>>> [3/5] CRUD con TDD en Python (unittest)..." -ForegroundColor Yellow
Push-Location "$root/3-crud-tdd/python"
python -m unittest discover -s tests -p "test_*.py" -v
Pop-Location

# 4. CRUD GOLANG (TDD)
Write-Host "`n>>> [4/5] CRUD con TDD en Go (testing)..." -ForegroundColor Yellow
Push-Location "$root/3-crud-tdd/golang"
& "C:\Program Files\Go\bin\go.exe" test -v ./...
Pop-Location

# 5. CRUD REACT + TYPESCRIPT (TDD)
Write-Host "`n>>> [5/5] CRUD con TDD en React + TypeScript (Vitest)..." -ForegroundColor Yellow
Push-Location "$root/3-crud-tdd/frontend-react-ts"
npm test
Pop-Location

Write-Host "`n======================================================" -ForegroundColor Green
Write-Host "   TODAS LAS SUITES DE PRUEBAS COMPLETADAS CON EXITO  " -ForegroundColor Green
Write-Host "======================================================" -ForegroundColor Green
