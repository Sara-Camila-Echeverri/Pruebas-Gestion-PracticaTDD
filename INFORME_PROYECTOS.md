# Informe de proyectos y flujo de ejecución

## 1. Visión general

Este repositorio es una colección didáctica sobre testing unitario, pruebas de integración, mocking y desarrollo guiado por pruebas (TDD).

Está dividido en tres bloques:

1. **JUnit 5 con Java y Kotlin**: pruebas sobre una calculadora.
2. **Testing unitario en Java**: parser y resolución de ecuaciones de primer grado.
3. **CRUD con TDD**: implementaciones independientes en React/TypeScript, Python y Go.

La ejecución global se coordina desde [`run_all_tests.ps1`](run_all_tests.ps1).

---

## 2. Flujo global de ejecución

El script global ejecuta las suites en este orden:

```text
Configuración de JDK 21
        |
        v
JUnit 5: Java y Kotlin
        |
        v
JUnit 4 + Mockito: proyecto Softtek
        |
        v
Python: unittest
        |
        v
Go: testing
        |
        v
React: Vitest
```

Los comandos principales son:

- Java/Kotlin: `ConsoleLauncher --scan-class-path`
- Java Softtek: `JUnitCore`
- Python: `python -m unittest discover`
- Go: `go test -v ./...`
- React: `npm test`

El script utiliza el JDK incluido en `tools/jdk-21`, además de las clases Java/Kotlin ya compiladas en las carpetas `bin`.

---

## 3. Proyecto JUnit 5 con Java y Kotlin

Ubicación: [`1-junit5-running-tests`](1-junit5-running-tests)

### Objetivo

Este proyecto reproduce ejemplos de la guía de JUnit 5 utilizando una calculadora implementada en dos lenguajes:

- Java: [`Calculator.java`](1-junit5-running-tests/java/src/main/java/com/example/project/Calculator.java)
- Kotlin: [`Calculator.kt`](1-junit5-running-tests/kotlin/src/main/kotlin/com/example/project/Calculator.kt)

Ambas clases ofrecen las operaciones:

- Suma.
- Resta.
- Multiplicación.
- División.

La división valida que el divisor no sea cero y lanza `IllegalArgumentException` cuando no es válido.

### Pruebas

Las pruebas Java están en [`CalculatorTests.java`](1-junit5-running-tests/java/src/test/java/com/example/project/CalculatorTests.java) y las de Kotlin en [`CalculatorTests.kt`](1-junit5-running-tests/kotlin/src/test/kotlin/com/example/project/CalculatorTests.kt).

Se utilizan las siguientes capacidades de JUnit 5:

- `@Test` para pruebas normales.
- `@BeforeEach` para crear una calculadora nueva antes de cada prueba.
- `@DisplayName` para nombres legibles.
- `@Tag` para clasificar pruebas.
- `@ParameterizedTest` para reutilizar una prueba con varios datos.
- `@CsvSource` para proporcionar casos de entrada.
- `assertAll` para agrupar varias aserciones.
- `assertThrows` para verificar excepciones.

Cada lenguaje aporta siete casos ejecutables, para un total de 14 casos entre Java y Kotlin.

### Flujo de una prueba

```text
@BeforeEach crea Calculator
        |
        v
Se ejecuta una operación
        |
        v
Se compara el resultado esperado
        |
        v
Se verifica una excepción si corresponde
```

---

## 4. Proyecto de ecuaciones y Mockito

Ubicación: [`2-softtek-testing-unitario`](2-softtek-testing-unitario)

Este bloque muestra la diferencia entre pruebas unitarias directas, pruebas de integración y pruebas unitarias con dobles de prueba.

### Modelo de dominio

La ecuación esperada tiene la forma:

```text
ax + b = c
```

La solución se obtiene mediante:

```text
x = (c - b) / a
```

Las clases principales son:

- [`Parseador.java`](2-softtek-testing-unitario/src/main/java/com/softtek/ecuacion/Parseador.java)
- [`EcuacionPrimerGrado.java`](2-softtek-testing-unitario/src/main/java/com/softtek/ecuacion/EcuacionPrimerGrado.java)

### `Parseador`

`Parseador` recibe una cadena como:

```text
2x - 1 = 0
```

Y obtiene:

- `parte1`: el coeficiente `a`, que vale `2`.
- `parte2`: el término independiente `b`, que vale `-1`.
- `parte3`: el lado derecho `c`, que vale `0`.
- El operador utilizado, `+` o `-`.

Internamente divide la ecuación por `=`, identifica el operador, separa los términos y convierte los valores de texto a enteros.

### `EcuacionPrimerGrado`

Esta clase coordina el cálculo:

```text
EcuacionPrimerGrado
        |
        v
Parseador obtiene a, b y c
        |
        v
Se calcula (c - b) / a
        |
        v
Se devuelve el resultado decimal
```

Ejemplo:

```text
2x + 1 = 10
(10 - 1) / 2 = 4.5
```

### Pruebas del parser

[`ParseadorTest.java`](2-softtek-testing-unitario/src/test/java/com/softtek/ecuacion/ParseadorTest.java) prueba directamente la extracción de cada parte y la identificación del operador.

Estas pruebas no comprueban el cálculo final.

### Pruebas de integración

[`EcuacionPrimerGradoIntegrationTest.java`](2-softtek-testing-unitario/src/test/java/com/softtek/ecuacion/EcuacionPrimerGradoIntegrationTest.java) utiliza el parser real y la clase calculadora real.

Comprueba:

- `2x - 1 = 0` produce `0.5`.
- `2x + 1 = 0` produce `-0.5`.
- `2x + 1 = 10` produce `4.5`.

Aquí se comprueba el flujo completo entre las dos clases.

### Pruebas con Mockito

[`EcuacionPrimerGradoMockitoTest.java`](2-softtek-testing-unitario/src/test/java/com/softtek/ecuacion/EcuacionPrimerGradoMockitoTest.java) reemplaza `Parseador` por un mock.

La prueba define manualmente las respuestas del parser:

```text
obtenerParte1 -> 2
obtenerParte2 -> -1
obtenerParte3 -> 0
```

De esta forma se prueba exclusivamente la lógica matemática de `EcuacionPrimerGrado`, sin depender del comportamiento real del parser.

El proyecto contiene nueve pruebas:

- Cuatro pruebas unitarias del parser.
- Tres pruebas de integración.
- Dos pruebas unitarias con Mockito.

---

## 5. CRUD con React y TypeScript

Ubicación: [`3-crud-tdd/frontend-react-ts`](3-crud-tdd/frontend-react-ts)

### Arranque

El flujo de renderizado es:

```text
index.html
    |
    v
main.tsx
    |
    v
App.tsx
    |
    v
TaskManager.tsx
```

El punto de entrada es [`main.tsx`](3-crud-tdd/frontend-react-ts/src/main.tsx). `App.tsx` renderiza [`TaskManager.tsx`](3-crud-tdd/frontend-react-ts/src/components/TaskManager.tsx).

El proyecto utiliza React, TypeScript, Vite, Vitest, React Testing Library y JSDOM.

### Modelo

El tipo de tarea está definido en [`types.ts`](3-crud-tdd/frontend-react-ts/src/types.ts):

```typescript
interface Task {
  id: string;
  title: string;
  completed: boolean;
}
```

### Create

El formulario:

1. Lee el título introducido.
2. Elimina espacios sobrantes.
3. Rechaza títulos vacíos.
4. Genera un ID con `Date.now()`.
5. Crea una tarea pendiente.
6. La añade al estado.
7. Limpia el campo de texto.

### Read

El componente recibe opcionalmente `initialTasks` y guarda las tareas en estado local.

Muestra:

- El total de tareas.
- Un mensaje cuando la lista está vacía.
- La lista de títulos.
- El estado completado de cada tarea.

### Update

Hay dos operaciones de actualización:

1. Cambiar `completed` mediante un checkbox.
2. Editar el título mediante un formulario temporal.

Al guardar una edición se reemplaza solamente el título de la tarea seleccionada.

### Delete

La eliminación filtra la tarea cuyo ID coincide y conserva las demás.

### Pruebas

Las pruebas están en [`TaskManager.test.tsx`](3-crud-tdd/frontend-react-ts/src/__tests__/TaskManager.test.tsx).

Se verifican siete escenarios:

- Estado vacío.
- Renderizado de tareas iniciales.
- Creación de una tarea.
- Rechazo de tareas vacías.
- Cambio de estado completado.
- Edición de título.
- Eliminación.

---

## 6. CRUD de productos en Python

Ubicación: [`3-crud-tdd/python`](3-crud-tdd/python)

La lógica está en [`product_service.py`](3-crud-tdd/python/src/product_service.py) y las pruebas en [`test_product_service.py`](3-crud-tdd/python/tests/test_product_service.py).

### Modelo y almacenamiento

El producto es un `dataclass` con:

- `id`
- `name`
- `price`
- `stock`

El servicio guarda los productos en un diccionario en memoria. No utiliza base de datos.

### Create

Valida que:

- El nombre no esté vacío.
- El precio no sea negativo.
- El stock no sea negativo.

Después genera un UUID, normaliza los datos, guarda el producto y lo devuelve.

### Read

- `get_by_id` devuelve un producto o lanza `ProductNotFoundError`.
- `get_all` devuelve todos los productos.

### Update

Permite actualizar de forma parcial el nombre, el precio y el stock. Los parámetros que llegan como `None` mantienen su valor anterior.

### Delete

Comprueba que el producto exista, lo elimina y devuelve `True`.

### Excepciones

- `ProductNotFoundError`: el ID no existe.
- `ValidationError`: los datos no cumplen las reglas.

La suite contiene 12 pruebas utilizando `unittest`.

---

## 7. CRUD de usuarios en Go

Ubicación: [`3-crud-tdd/golang`](3-crud-tdd/golang)

La implementación está en [`user_service.go`](3-crud-tdd/golang/crud/user_service.go) y las pruebas en [`user_service_test.go`](3-crud-tdd/golang/crud/user_service_test.go).

### Modelo

Cada usuario contiene:

- ID.
- Nombre.
- Email.
- Rol.
- Fecha de creación.
- Fecha de actualización.

También tiene etiquetas JSON para facilitar una futura exposición mediante API.

### Almacenamiento y concurrencia

Los usuarios se guardan en un mapa:

```go
map[string]*User
```

El acceso está protegido con `sync.RWMutex`:

- `RLock` para lecturas.
- `Lock` para escrituras.

Esto permite utilizar el servicio con acceso concurrente sin modificar el mapa simultáneamente desde varias operaciones.

### Create

El método:

1. Limpia nombre, email y rol.
2. Valida nombre y email.
3. Rechaza emails duplicados sin distinguir mayúsculas y minúsculas.
4. Genera IDs como `usr-0001`.
5. Registra las fechas.
6. Guarda y devuelve el usuario.

### Read

- `GetByID` consulta un usuario concreto.
- `GetAll` devuelve la colección completa.

### Update

Actualiza el nombre y, si se proporciona, el rol. El email no se modifica desde este método.

También actualiza `UpdatedAt`.

### Delete

Elimina el usuario si existe y devuelve `ErrUserNotFound` cuando el ID no está registrado.

### Errores

- `ErrUserNotFound`
- `ErrInvalidInput`
- `ErrDuplicateEmail`

Las pruebas están organizadas como cinco subpruebas: crear, buscar por ID, listar, actualizar y eliminar.

---

## 8. Dependencias y herramientas

El script [`setup_tools.py`](tools/setup_tools.py) descarga las dependencias Java necesarias:

- JUnit Platform Console.
- JUnit 4.
- Hamcrest.
- Mockito.
- Byte Buddy.
- Objenesis.

El frontend obtiene sus dependencias mediante `npm` y [`package.json`](3-crud-tdd/frontend-react-ts/package.json).

Python y Go utilizan principalmente sus bibliotecas estándar.

---

## 9. Observaciones técnicas

1. Java y Kotlin se ejecutan desde clases ya compiladas. El script global no compila los fuentes antes de probarlos.
2. El script imprime un mensaje final de éxito, pero no comprueba explícitamente cada código de salida ni detiene el proceso ante un fallo.
3. La ruta del ejecutable de Go está fija en `C:\Program Files\Go\bin\go.exe`, por lo que puede variar entre equipos.
4. Los tres CRUD almacenan datos únicamente en memoria.
5. Las tareas React desaparecen al recargar la página porque no se usa backend, `localStorage` ni base de datos.
6. El parser de ecuaciones está orientado a formatos simples como `2x + 1 = 0` y no parece cubrir expresiones más complejas.
7. Las pruebas actuales demuestran el comportamiento final, pero el historial completo de cada ciclo Rojo-Verde-Refactor no está documentado en el repositorio.

---

## 10. Comandos independientes

Desde la raíz del repositorio:

```powershell
.\run_all_tests.ps1
```

React:

```powershell
cd 3-crud-tdd/frontend-react-ts
npm test
```

Python:

```powershell
cd 3-crud-tdd/python
python -m unittest discover -s tests -p "test_*.py" -v
```

Go:

```powershell
cd 3-crud-tdd/golang
go test -v ./...
```

Para ejecutar la aplicación React en modo desarrollo:

```powershell
cd 3-crud-tdd/frontend-react-ts
npm run dev
```
