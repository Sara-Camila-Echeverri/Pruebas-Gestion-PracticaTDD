# Prácticas de Testing Unitario, JUnit 5 y CRUDs con TDD

Repositorio con la solución completa a las actividades de pruebas de software, ejecución de pruebas en múltiples lenguajes y desarrollo guiado por pruebas (TDD).

---

## Contenido del Repositorio

### 1. JUnit 5 – Running Tests en Java y Kotlin (`1-junit5-running-tests/`)
Implementación de las pruebas y modelos descritos en la [Guía Oficial de JUnit 5 (Running Tests)](https://junit.org/junit5/docs/current/user-guide/#running-tests) y sus proyectos de inicio:
- **Java**: `Calculator.java` y `CalculatorTests.java` utilizando anotaciones `@Test`, `@DisplayName`, `@ParameterizedTest`, `@CsvSource`, `@Tag`, `assertAll` y `assertThrows`.
- **Kotlin**: `Calculator.kt` y `CalculatorKotlinTests.kt` utilizando aserciones y características nativas de Kotlin para JUnit 5 (`assertAll`, lambdas, tests parametrizados).
- **Ejecución**: Ejecutado conjuntamente con **JUnit Platform Console Launcher**, detectando y pasando 14 pruebas al 100%.

### 2. Testing Unitario – Blog de Softtek (`2-softtek-testing-unitario/`)
Implementación del ejercicio práctico del artículo [Guía rápida y definitiva para iniciarse con testing unitario](https://blog.softtek.com/es/testing-unitario):
- **Clases de Dominio**:
  - `Parseador.java`: Análisis y parseo de ecuaciones lineales de primer grado ($ax \pm b = c$).
  - `EcuacionPrimerGrado.java`: Resolución de la ecuación mediante $x = \frac{c - b}{a}$.
- **Suites de Pruebas**:
  - `ParseadorTest.java`: Pruebas unitarias directas del SUT `Parseador` (4 tests).
  - `EcuacionPrimerGradoIntegrationTest.java`: Pruebas de integración del flujo de cálculo (3 tests).
  - `EcuacionPrimerGradoMockitoTest.java`: Pruebas unitarias aislando dependencias mediante dobles de prueba con **Mockito** (`@Mock`, `@InjectMocks`, `when().thenReturn()`) (2 tests).

### 3. CRUD en 3 Lenguajes Diferentes con TDD (`3-crud-tdd/`)
Implementaciones completas de operaciones CRUD (Create, Read, Update, Delete) aplicando la metodología TDD (Rojo $\to$ Verde $\to$ Refactorizar), sin utilizar Java ni Kotlin:
1. **Frontend Framework – TypeScript + React** (`frontend-react-ts/`):
   - Componente interactivo `TaskManager.tsx` con soporte para crear, leer, editar título, alternar estado y eliminar tareas.
   - Suite de pruebas TDD con **Vitest** y **React Testing Library** (7 tests).
2. **Python** (`python/`):
   - Servicio de inventario `product_service.py` con validación de datos, UUIDs y manejo de excepciones.
   - Suite de pruebas TDD con el módulo estándar `unittest` (12 tests).
3. **Go (Golang)** (`golang/`):
   - Gestor de usuarios `user_service.go` con control de concurrencia (`sync.RWMutex`), validación de duplicados y errores tipados.
   - Suite de pruebas TDD con el paquete estándar `testing` (5 suites de pruebas).

---

## Estructura del Proyecto

```text
├── 1-junit5-running-tests/
│   ├── java/src/main/java/com/example/project/Calculator.java
│   ├── java/src/test/java/com/example/project/CalculatorTests.java
│   ├── kotlin/src/main/kotlin/com/example/project/Calculator.kt
│   └── kotlin/src/test/kotlin/com/example/project/CalculatorKotlinTests.kt
│
├── 2-softtek-testing-unitario/
│   ├── src/main/java/com/softtek/ecuacion/EcuacionPrimerGrado.java
│   ├── src/main/java/com/softtek/ecuacion/Parseador.java
│   └── src/test/java/com/softtek/ecuacion/
│       ├── ParseadorTest.java
│       ├── EcuacionPrimerGradoIntegrationTest.java
│       └── EcuacionPrimerGradoMockitoTest.java
│
├── 3-crud-tdd/
│   ├── frontend-react-ts/       # React + Vite + Vitest + Testing Library
│   ├── python/                  # Python 3 + unittest
│   └── golang/                  # Go + testing
│
├── tools/                       # Scripts auxiliares de dependencias y JARs
├── build.ps1                    # Script para compilar proyectos Java y Kotlin
├── run_all_tests.ps1            # Script para ejecutar toda la suite de pruebas (PowerShell)
├── run_all_tests.sh             # Script para ejecutar toda la suite de pruebas (Linux/Bash/Docker)
├── Dockerfile                   # Contenedor multi-runtime para ejecución aislada
├── docker-compose.yml           # Configuración para ejecutar pruebas con Docker Compose
├── Justfile                     # Tareas automatizadas con el task-runner Just
└── .gitignore                   # Exclusión de binarios, node_modules y caches
```

---

## Compilación y Ejecución de las Pruebas

### 1. Con PowerShell (Nativo Windows)

- **Compilar código Java y Kotlin**:
  ```powershell
  .\build.ps1
  ```

- **Ejecutar todas las pruebas a la vez**:
  ```powershell
  .\run_all_tests.ps1
  ```

### 2. Con el task runner `just` (Recomendado)

Si cuentas con `just` instalado:

```powershell
just              # Lista todas las recetas disponibles
just build        # Compila proyectos Java y Kotlin
just test         # Ejecuta las 5 suites de pruebas completas
just test-java    # Ejecuta solo JUnit 5 (Java y Kotlin)
just test-softtek # Ejecuta solo Softtek (JUnit 4 + Mockito)
just test-python  # Ejecuta solo Python (unittest)
just test-go      # Ejecuta solo Go (testing)
just test-react   # Ejecuta solo React (Vitest)
just watch        # Modo observador continuo con watchexec
```

### 3. Con Docker (Entorno Aislado Multi-Runtime)

Para correr todas las pruebas sin necesidad de instalar runtimes localmente:

```bash
# Con Docker Compose:
docker compose up --build

# O con Docker CLI:
docker build -t pruebas-gestion-tdd .
docker run --rm pruebas-gestion-tdd
```

### 4. De forma independiente por tecnología

- **React / TypeScript (Frontend)**:
  ```powershell
  cd 3-crud-tdd/frontend-react-ts
  npm test
  ```
- **Python**:
  ```powershell
  cd 3-crud-tdd/python
  python -m unittest discover -s tests -p "test_*.py" -v
  ```
- **Go**:
  ```powershell
  cd 3-crud-tdd/golang
  go test -v ./...
  ```
- **Java / Kotlin (JUnit 5)**:
  ```powershell
  just test-java
  ```
- **Softtek (JUnit 4 + Mockito)**:
  ```powershell
  just test-softtek
  ```
