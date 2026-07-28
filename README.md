# Hogar360

Hogar360 es una aplicación móvil para apoyar tareas básicas de remodelación del hogar. La primera versión se enfoca en calcular cuántas cajas de mayólicas comprar según las medidas del piso y en preparar una base para una futura paleta de colores de pintura.

El proyecto está dividido en dos partes:

- `mobile/`: aplicación Flutter para Android.
- `backend/`: API REST con Node.js, Express, TypeScript y MongoDB Atlas.

## Funciones actuales

- Pantalla de bienvenida.
- Registro e inicio de sesión.
- Sesión persistente en el dispositivo.
- Cierre de sesión desde Perfil.
- Home con saludo personalizado.
- Calculadora de cerámicos/mayólicas.
- Guardado de resultados en historial por usuario.
- Perfil con resumen de cálculos guardados.
- Edición del nombre del usuario.
- Sección de pintura marcada como "Próximamente".

## Modelo de cálculo

La calculadora usa el mismo modelo en frontend y backend:

```text
areaPiso = largoPiso * anchoPiso
areaPieza = (largoCeramicoCm / 100) * (anchoCeramicoCm / 100)
piezasBase = ceil(areaPiso / areaPieza)
piezasMerma = ceil(piezasBase * merma / 100)
piezasTotales = piezasBase + piezasMerma
cajas = ceil(piezasTotales / piezasPorCaja)
```

Ejemplo:

```text
Piso: 4 m x 4 m = 16 m2
Pieza: 20 cm x 20 cm = 0.04 m2
Piezas base: 400
Merma 10%: 40
Piezas totales: 440
Cajas de 10 piezas: 44 cajas
```

## Stack utilizado

| Parte | Tecnología | Uso |
|---|---|---|
| Mobile | Flutter / Dart | Aplicación Android multiplataforma. |
| Estado UI | `ChangeNotifier` / ViewModels | Manejo de estado por módulo. |
| HTTP mobile | `http` | Consumo de la API REST. |
| Sesión local | `shared_preferences` | Persistencia de token, nombre y correo. |
| Backend | Node.js + Express | API REST. |
| Backend lenguaje | TypeScript | Tipado y compilación segura. |
| Base de datos | MongoDB Atlas | Usuarios, sesiones e historial de cálculos. |
| Contenedores | Docker Alpine | Ejecución portable del backend. |
| Deploy backend | Render Web Service | Despliegue de la API. |

## Arquitectura general

```mermaid
graph TD
    A[Usuario] --> B[App Flutter]
    B --> C[API REST Express]
    C --> D[(MongoDB Atlas)]
```

## Estructura

```text
Hogar360/
├── backend/
│   ├── src/
│   │   ├── config/
│   │   ├── middlewares/
│   │   ├── modules/
│   │   │   ├── auth/
│   │   │   ├── paint/
│   │   │   └── tiles/
│   │   ├── routes/
│   │   └── server.ts
│   ├── Dockerfile
│   └── package.json
├── mobile/
│   ├── lib/
│   │   ├── app/
│   │   ├── core/
│   │   └── modules/
│   ├── android/
│   └── pubspec.yaml
├── render.yaml
└── README.md
```

## Backend

Variables requeridas en `backend/.env`:

```env
PORT=3000
NODE_ENV=development
MONGODB_URI=mongodb+srv://usuario:password@cluster.mongodb.net/?retryWrites=true&w=majority&appName=Hogar360
MONGODB_DB_NAME=hogar360
```

Comandos:

```powershell
cd backend
npm install
npm run dev
npm run check
npm run build
npm start
```

Stress test local:

```powershell
cd backend
$env:API_BASE_URL='http://127.0.0.1:3000'
$env:STRESS_TOTAL='1000'
$env:STRESS_CONCURRENCY='50'
npm run stress
```

## Mobile

Comandos principales:

```powershell
cd mobile
flutter pub get
flutter analyze
flutter test
flutter run
```

Para compilar apuntando al backend local en emulador Android:

```powershell
flutter build apk --release --dart-define=API_BASE_URL=http://10.0.2.2:3000/api
```

Para compilar apuntando a Render:

```powershell
flutter build apk --release --dart-define=API_BASE_URL=https://TU-BACKEND.onrender.com/api
flutter build appbundle --release --dart-define=API_BASE_URL=https://TU-BACKEND.onrender.com/api
```

## Deploy en Render

El backend debe crearse como **Web Service**.

Configuración recomendada:

```text
Root Directory: backend
Build Command: npm ci && npm run build
Start Command: npm start
Health Check Path: /health
```

Variables en Render:

```text
NODE_ENV=production
MONGODB_URI=<conexion de MongoDB Atlas>
MONGODB_DB_NAME=hogar360
```

También existe `render.yaml` para usar Render Blueprints.

## Publicación Android

Antes de subir a Uptodown o Aptoide:

- Cambiar `API_BASE_URL` al dominio real de Render.
- Crear una firma release real con keystore.
- Crear `mobile/android/key.properties` usando `mobile/android/key.properties.example`.
- Generar APK o AAB release.

Artefactos:

```text
mobile/build/app/outputs/flutter-apk/app-release.apk
mobile/build/app/outputs/bundle/release/app-release.aab
```

## Validaciones usadas

```powershell
cd mobile
flutter analyze
flutter test
flutter build apk --release
flutter build appbundle --release

cd ../backend
npm run check
npm run build
npm run stress
```
