Write-Host "======================================================" -ForegroundColor Cyan
Write-Host "       COMPILANDO PROYECTOS JAVA Y KOTLIN             " -ForegroundColor Cyan
Write-Host "======================================================" -ForegroundColor Cyan

$root = $PSScriptRoot
if (-not $root) { $root = Get-Location }

# Configurar Java Runtime JDK 21
if (-not (Test-Path "$root\tools\jdk-21") -and (Test-Path "$env:USERPROFILE\scoop\apps\openjdk21\current")) {
    $env:JAVA_HOME = "$env:USERPROFILE\scoop\apps\openjdk21\current"
} else {
    $env:JAVA_HOME = "$root\tools\jdk-21"
}
$env:PATH = "$env:JAVA_HOME\bin;$env:PATH"
$javacExe = if (Test-Path "$env:JAVA_HOME\bin\javac.exe") { "$env:JAVA_HOME\bin\javac.exe" } else { "javac" }

$kotlincBat = if (Test-Path "$root/tools/kotlinc/bin/kotlinc.bat") {
    "$root/tools/kotlinc/bin/kotlinc.bat"
} elseif (Test-Path "$env:USERPROFILE/scoop/apps/kotlin/current/bin/kotlinc.bat") {
    "$env:USERPROFILE/scoop/apps/kotlin/current/bin/kotlinc.bat"
} else {
    "kotlinc"
}

# Asegurar directorios bin
New-Item -ItemType Directory -Force -Path "$root/1-junit5-running-tests/bin/java" | Out-Null
New-Item -ItemType Directory -Force -Path "$root/1-junit5-running-tests/bin/kotlin" | Out-Null
New-Item -ItemType Directory -Force -Path "$root/2-softtek-testing-unitario/bin" | Out-Null

$junitJar = "$root/tools/junit-platform-console-standalone-1.10.2.jar"

# 1. Compilar Java JUnit 5
Write-Host ">>> Compilando 1-junit5-running-tests (Java)..." -ForegroundColor Yellow
$javaFiles = Get-ChildItem -Recurse "$root/1-junit5-running-tests/java/src/*.java" | ForEach-Object { $_.FullName }
& $javacExe -cp "$junitJar" -d "$root/1-junit5-running-tests/bin/java" $javaFiles

# 2. Compilar Kotlin JUnit 5
Write-Host ">>> Compilando 1-junit5-running-tests (Kotlin)..." -ForegroundColor Yellow
$kotlinFiles = Get-ChildItem -Recurse "$root/1-junit5-running-tests/kotlin/src/*.kt" | ForEach-Object { $_.FullName }
& $kotlincBat -cp "$junitJar;$root/1-junit5-running-tests/bin/java" -d "$root/1-junit5-running-tests/bin/kotlin" $kotlinFiles

# 3. Compilar Softtek
Write-Host ">>> Compilando 2-softtek-testing-unitario (Java)..." -ForegroundColor Yellow
$cpSofttek = "$junitJar;$root/tools/junit-4.13.2.jar;$root/tools/hamcrest-core-1.3.jar;$root/tools/mockito-core-5.11.0.jar;$root/tools/byte-buddy-1.14.12.jar;$root/tools/byte-buddy-agent-1.14.12.jar;$root/tools/objenesis-3.3.jar"
$softtekFiles = Get-ChildItem -Recurse "$root/2-softtek-testing-unitario/src/*.java" | ForEach-Object { $_.FullName }
& $javacExe -cp "$cpSofttek" -d "$root/2-softtek-testing-unitario/bin" $softtekFiles

Write-Host ">>> Compilacion completada con exito." -ForegroundColor Green
