# Backend de Hogar360

## 1. Objetivo

El backend de Hogar360 centraliza la autenticación, los cálculos de mayólicas y la información de colores de pintura. Su función es ofrecer una API REST clara para que la app Flutter pueda consultar y guardar información sin duplicar lógica importante en el cliente.

---

## 2. Responsabilidades principales

- Registrar usuarios.
- Iniciar sesión.
- Validar tokens de autenticación.
- Calcular cantidad de mayólicas y cajas.
- Guardar historial de cálculos, si se decide incluirlo.
- Entregar la lista de colores de pintura.
- Permitir que el catálogo de colores pueda crecer sin actualizar toda la app.

---

## 3. Módulos del backend

### Auth

Responsable de usuarios y sesión.

Endpoints sugeridos:

- `POST /api/auth/register`
- `POST /api/auth/login`
- `GET /api/auth/me`

### Tiles

Responsable del cálculo de mayólicas.

Endpoints sugeridos:

- `POST /api/tiles/calculate`
- `GET /api/tiles/history`
- `GET /api/tiles/history/:id`

El historial puede dejarse como opcional para el MVP si se quiere avanzar más rápido.

### Paint

Responsable de la paleta de colores.

Endpoints sugeridos:

- `GET /api/paint/colors`
- `GET /api/paint/colors/:id`

En una versión administrativa futura se podrían agregar endpoints para crear, editar o eliminar colores.

---

## 4. Fórmula base para mayólicas

Datos de entrada:

- `floorLength`
- `floorWidth`
- `tileLength`
- `tileWidth`
- `tilesPerBox`
- `wastePercentage`

Cálculos:

```txt
floorArea = floorLength * floorWidth
tileArea = tileLength * tileWidth
baseTiles = ceil(floorArea / tileArea)
wasteTiles = ceil(baseTiles * (wastePercentage / 100))
totalTiles = baseTiles + wasteTiles
boxes = ceil(totalTiles / tilesPerBox)
```

Recomendaciones:

- Usar una sola unidad de medida internamente, preferentemente metros.
- Validar que todas las medidas sean mayores que cero.
- Definir una merma por defecto, por ejemplo 10%.
- Redondear siempre hacia arriba porque no se pueden comprar fracciones de mayólicas o cajas.

---

## 5. Datos principales

### User

Campos sugeridos:

- `name`
- `email`
- `passwordHash`
- `createdAt`
- `updatedAt`

### TileCalculation

Campos sugeridos:

- `userId`
- `floorLength`
- `floorWidth`
- `tileLength`
- `tileWidth`
- `tilesPerBox`
- `wastePercentage`
- `floorArea`
- `tileArea`
- `baseTiles`
- `totalTiles`
- `boxes`
- `createdAt`

### PaintColor

Campos sugeridos:

- `name`
- `hex`
- `family`
- `description`
- `isActive`

---

## 6. Seguridad básica

- Guardar contraseñas con hash, nunca en texto plano.
- Usar JWT o sesiones seguras para autenticación.
- Proteger endpoints privados con middleware.
- Validar datos de entrada antes de calcular o guardar.
- No devolver información sensible del usuario.

---

## 7. Conclusión

El backend debe ser simple y modular. Para el alcance actual, basta con Auth, Tiles y Paint. Los módulos de habitaciones, muebles, listas de compra y PDF pueden añadirse después sin cambiar la base de la arquitectura.
