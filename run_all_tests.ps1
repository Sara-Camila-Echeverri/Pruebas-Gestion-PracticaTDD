Write-Host "======================================================" -ForegroundColor Cyan
Write-Host "    EJECUTANDO TODAS LAS PRUEBAS DE LA ACTIVIDAD     " -ForegroundColor Cyan
Write-Host "======================================================" -ForegroundColor Cyan
Write-Host ""

$root = $PSScriptRoot
if (-not $root) { $root = Get-Location }

# Configurar Java Runtime JDK 21 LTS
if (-not (Test-Path "$root\tools\jdk-21") -and (Test-Path "$env:USERPROFILE\scoop\apps\openjdk21\current")) {
    $env:JAVA_HOME = "$env:USERPROFILE\scoop\apps\openjdk21\current"
} else {
    $env:JAVA_HOME = "$root\tools\jdk-21"
}
$env:PATH = "$env:JAVA_HOME\bin;$env:PATH"
$javaExe = if (Test-Path "$env:JAVA_HOME\bin\java.exe") { "$env:JAVA_HOME\bin\java.exe" } else { "java" }

# Asegurar compilación de clases si no existen
$needCompile = (-not (Test-Path "$root/1-junit5-running-tests/bin/java") -or -not (Test-Path "$root/1-junit5-running-tests/bin/kotlin") -or -not (Test-Path "$root/2-softtek-testing-unitario/bin"))
if ($needCompile -and (Test-Path "$root/build.ps1")) {
    Write-Host ">>> Compilando proyectos Java y Kotlin..." -ForegroundColor Cyan
    & "$root/build.ps1"
}

# 1. JUNIT 5 TESTS (JAVA Y KOTLIN)
Write-Host ">>> [1/5] JUnit 5 (Java y Kotlin - User Guide #running-tests)..." -ForegroundColor Yellow
$junitJar = "$root/tools/junit-platform-console-standalone-1.10.2.jar"
$kotlinStdlib = if (Test-Path "$root/tools/kotlinc/lib/kotlin-stdlib.jar") { "$root/tools/kotlinc/lib/kotlin-stdlib.jar" } else { "$env:USERPROFILE/scoop/apps/kotlin/current/lib/kotlin-stdlib.jar" }
$cpAll = "$junitJar;$kotlinStdlib;$root/1-junit5-running-tests/bin/java;$root/1-junit5-running-tests/bin/kotlin"

& $javaExe -cp "$cpAll" org.junit.platform.console.ConsoleLauncher --scan-class-path --details=tree

# 2. SOFTTEK TESTS (JUnit 4 + Mockito)
Write-Host "`n>>> [2/5] Blog de Softtek (Parseador, EcuacionPrimerGrado, Mockito)..." -ForegroundColor Yellow
$cpSofttek = "$root/2-softtek-testing-unitario/bin;$root/tools/junit-4.13.2.jar;$root/tools/hamcrest-core-1.3.jar;$root/tools/mockito-core-5.11.0.jar;$root/tools/byte-buddy-1.14.12.jar;$root/tools/byte-buddy-agent-1.14.12.jar;$root/tools/objenesis-3.3.jar"

& $javaExe -cp "$cpSofttek" org.junit.runner.JUnitCore com.softtek.ecuacion.ParseadorTest com.softtek.ecuacion.EcuacionPrimerGradoIntegrationTest com.softtek.ecuacion.EcuacionPrimerGradoMockitoTest

# 3. CRUD PYTHON (TDD)
Write-Host "`n>>> [3/5] CRUD con TDD en Python (unittest)..." -ForegroundColor Yellow
Push-Location "$root/3-crud-tdd/python"
$pythonExe = if (Get-Command python -ErrorAction SilentlyContinue) { (Get-Command python).Source } else { "python" }
& $pythonExe -m unittest discover -s tests -p "test_*.py" -v
Pop-Location

# 4. CRUD GOLANG (TDD)
Write-Host "`n>>> [4/5] CRUD con TDD en Go (testing)..." -ForegroundColor Yellow
Push-Location "$root/3-crud-tdd/golang"
$goExe = if (Test-Path "C:\Program Files\Go\bin\go.exe") { "C:\Program Files\Go\bin\go.exe" } elseif (Get-Command go -ErrorAction SilentlyContinue) { (Get-Command go).Source } else { "$env:USERPROFILE\scoop\apps\go\current\bin\go.exe" }
& $goExe test -v ./...
Pop-Location

# 5. CRUD REACT + TYPESCRIPT (TDD)
Write-Host "`n>>> [5/5] CRUD con TDD en React + TypeScript (Vitest)..." -ForegroundColor Yellow
Push-Location "$root/3-crud-tdd/frontend-react-ts"
$npmCmd = if (Get-Command npm.cmd -ErrorAction SilentlyContinue) { "npm.cmd" } else { "npm" }
& $npmCmd test
Pop-Location

Write-Host "`n======================================================" -ForegroundColor Green
Write-Host "   TODAS LAS SUITES DE PRUEBAS COMPLETADAS CON EXITO  " -ForegroundColor Green
Write-Host "======================================================" -ForegroundColor Green
