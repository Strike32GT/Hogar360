# Hogar360 Mobile

Aplicación móvil de Hogar360 construida con Flutter. Esta app consume el backend REST de Hogar360 para autenticación, perfil e historial de cálculos.

## Tecnologías usadas

| Tecnología | Uso |
|---|---|
| Flutter | Framework principal de la app móvil. |
| Dart | Lenguaje de desarrollo. |
| Material Design | Componentes visuales base. |
| `http` | Comunicación con el backend REST. |
| `shared_preferences` | Persistencia local de sesión. |
| `flutter_test` | Pruebas de widgets y lógica. |
| Android Gradle | Build APK/AAB. |

## Funciones implementadas

- Splash inicial.
- Bienvenida.
- Login y registro conectados al backend.
- Persistencia de sesión.
- Home sin botón de atrás.
- Cierre de sesión desde Perfil.
- Edición del nombre de usuario.
- Calculadora de cerámicos.
- Guardado de resultados.
- Historial de cálculos.
- Perfil con métricas obtenidas del backend.
- Sección de pintura como "Próximamente".

## Estructura principal

```text
lib/
├── app/
│   ├── app.dart
│   ├── routes.dart
│   └── theme.dart
├── core/
│   ├── network/
│   ├── session/
│   └── widgets/
└── modules/
    ├── auth/
    ├── home/
    ├── paint_palette/
    ├── profile/
    └── tiles_calculator/
```

## Configuración de API

La URL del backend se define con `API_BASE_URL`.

Por defecto, la app usa:

```text
http://10.0.2.2:3000/api
```

Ese valor sirve para Android Emulator conectándose a un backend local.

Para producción se debe compilar con:

```powershell
flutter build apk --release --dart-define=API_BASE_URL=https://TU-BACKEND.onrender.com/api
```

## Comandos de desarrollo

```powershell
flutter pub get
flutter analyze
flutter test
flutter run
```

## Builds

APK release:

```powershell
flutter build apk --release --dart-define=API_BASE_URL=https://TU-BACKEND.onrender.com/api
```

AAB release:

```powershell
flutter build appbundle --release --dart-define=API_BASE_URL=https://TU-BACKEND.onrender.com/api
```

Salidas:

```text
build/app/outputs/flutter-apk/app-release.apk
build/app/outputs/bundle/release/app-release.aab
```

## Firma Android

Para publicar en una tienda se debe usar una firma release real.

Crear:

```text
android/key.properties
android/app/upload-keystore.jks
```

Usar como referencia:

```text
android/key.properties.example
```

El archivo real `key.properties` y el keystore están ignorados por Git.

## Assets

Logos usados:

```text
assets/Hogar_360_Logo.png
assets/Hogar_360_Logo_Recortado.png
```

El logo recortado se usa como icono de la aplicación Android.

## Pruebas actuales

El proyecto incluye pruebas para:

- Mostrar bienvenida cuando no hay sesión.
- Fórmula de cálculo de cajas.
- Activación del botón Guardar al editar perfil.
- Home sin botón de atrás.

Ejecutar:

```powershell
flutter test
```
