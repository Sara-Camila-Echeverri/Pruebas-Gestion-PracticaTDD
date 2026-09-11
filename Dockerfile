# syntax=docker/dockerfile:1
FROM ubuntu:24.04

# Evitar prompts interactivos durante apt
ENV DEBIAN_FRONTEND=noninteractive
ENV LANG=C.UTF-8
ENV LC_ALL=C.UTF-8

# 1. Instalar dependencias del sistema y runtimes base
RUN apt-get update && apt-get install -y --no-install-recommends \
    ca-certificates \
    curl \
    wget \
    unzip \
    git \
    openjdk-21-jdk \
    python3 \
    golang-go \
    nodejs \
    npm \
    && rm -rf /var/lib/apt/lists/*

# 2. Instalar Kotlin Compiler
ENV KOTLIN_VERSION=2.0.0
RUN curl -fsSL "https://github.com/JetBrains/kotlin/releases/download/v${KOTLIN_VERSION}/kotlin-compiler-${KOTLIN_VERSION}.zip" -o /tmp/kotlinc.zip \
    && unzip /tmp/kotlinc.zip -d /opt \
    && rm /tmp/kotlinc.zip
ENV PATH="/opt/kotlinc/bin:${PATH}"

# 3. Definir directorio de trabajo
WORKDIR /app

# 4. Copiar todo el código del repositorio
COPY . .

# 5. Asegurar ejecutables y herramientas auxiliares
RUN chmod +x run_all_tests.sh

# 6. Descargar los JARs de testing requeridos
RUN python3 tools/setup_tools.py

# 7. Instalar dependencias de frontend (React + Vitest)
RUN cd 3-crud-tdd/frontend-react-ts && npm ci || npm install

# 8. Compilar los proyectos Java y Kotlin
RUN mkdir -p 1-junit5-running-tests/bin/java \
             1-junit5-running-tests/bin/kotlin \
             2-softtek-testing-unitario/bin \
    && javac -cp tools/junit-platform-console-standalone-1.10.2.jar \
       -d 1-junit5-running-tests/bin/java \
       $(find 1-junit5-running-tests/java/src -name "*.java") \
    && kotlinc -cp "tools/junit-platform-console-standalone-1.10.2.jar:1-junit5-running-tests/bin/java" \
       -d 1-junit5-running-tests/bin/kotlin \
       $(find 1-junit5-running-tests/kotlin/src -name "*.kt") \
    && javac -cp "tools/junit-platform-console-standalone-1.10.2.jar:tools/junit-4.13.2.jar:tools/hamcrest-core-1.3.jar:tools/mockito-core-5.11.0.jar:tools/byte-buddy-1.14.12.jar:tools/byte-buddy-agent-1.14.12.jar:tools/objenesis-3.3.jar" \
       -d 2-softtek-testing-unitario/bin \
       $(find 2-softtek-testing-unitario/src -name "*.java")

# 9. Comando por defecto: ejecutar la suite completa de pruebas
CMD ["./run_all_tests.sh"]